#include <jni.h>
#include "com_avos_uluru_breakpad_BreakpadMinidumpStackwalker.h"

#include <stdio.h>
#include <string.h>

#include <string>
#include <vector>

#include "common/scoped_ptr.h"
#include "common/using_std_string.h"
#include "google_breakpad/processor/call_stack.h"
#include "google_breakpad/processor/code_module.h"
#include "google_breakpad/processor/code_modules.h"
#include "google_breakpad/processor/basic_source_line_resolver.h"
#include "google_breakpad/processor/minidump.h"
#include "google_breakpad/processor/minidump_processor.h"
#include "google_breakpad/processor/process_state.h"
#include "google_breakpad/processor/stack_frame_cpu.h"

#include "processor/logging.h"
#include "processor/pathname_stripper.h"
#include "processor/simple_symbol_supplier.h"
#include "processor/stackwalk_common.h"

using google_breakpad::BasicSourceLineResolver;
using google_breakpad::Minidump;
using google_breakpad::MinidumpProcessor;
using google_breakpad::ProcessState;
using google_breakpad::SimpleSymbolSupplier;
using google_breakpad::scoped_ptr;
using google_breakpad::CallStack;
using google_breakpad::StackFrame;
using google_breakpad::PathnameStripper;
using google_breakpad::CodeModule;
using google_breakpad::CodeModules;

using std::string;
using std::vector;

static const char kOutputSeparator = '|';

// StripSeparator takes a string |original| and returns a copy
// of the string with all occurences of |kOutputSeparator| removed.
static string StripSeparator(const string &original) {
  string result = original;
  string::size_type position = 0;
  while ((position = result.find(kOutputSeparator, position)) != string::npos) {
    result.erase(position, 1);
  }
  position = 0;
  while ((position = result.find('\n', position)) != string::npos) {
    result.erase(position, 1);
  }
  return result;
}

string PrintStackMachineReadable(int thread_num, const CallStack *stack) {
  int frame_count = stack->frames()->size();
  string result = "";
  for (int frame_index = 0; frame_index < frame_count; ++frame_index) {
    const StackFrame *frame = stack->frames()->at(frame_index);
    char buffer[1024]; 
    sprintf(buffer, "%d%c%d%c", thread_num, kOutputSeparator, frame_index, kOutputSeparator);
    result += buffer;

    uint64_t instruction_address = frame->ReturnAddress();

    if (frame->module) {
      assert(!frame->module->code_file().empty());
      sprintf(buffer, "%s", StripSeparator(PathnameStripper::File(frame->module->code_file())).c_str());
      result += buffer;
      if (!frame->function_name.empty()) {
        sprintf(buffer, "%c%s", kOutputSeparator, StripSeparator(frame->function_name).c_str());
        result += buffer;
        if (!frame->source_file_name.empty()) {
          sprintf(buffer, 
		  "%c%s%c%d%c0x%" PRIx64,
		  kOutputSeparator,
		  StripSeparator(frame->source_file_name).c_str(),
		  kOutputSeparator,
		  frame->source_line,
		  kOutputSeparator,
		  instruction_address - frame->source_line_base);
	  result += buffer;
        } else {
          sprintf(buffer,
		  "%c%c%c0x%" PRIx64,
		  kOutputSeparator,  // empty source file
		  kOutputSeparator,  // empty source line
		  kOutputSeparator,
		  instruction_address - frame->function_base);
	  result += buffer;
        }
      } else {
        sprintf(buffer,
		"%c%c%c%c0x%" PRIx64,
		kOutputSeparator,  // empty function name
		kOutputSeparator,  // empty source file
		kOutputSeparator,  // empty source line
		kOutputSeparator,
		instruction_address - frame->module->base_address());
	result += buffer;
      }
    } else {
      // the printf before this prints a trailing separator for module name
      sprintf(buffer,
	      "%c%c%c%c0x%" PRIx64,
	      kOutputSeparator,  // empty function name
	      kOutputSeparator,  // empty source file
	      kOutputSeparator,  // empty source line
	      kOutputSeparator,
	      instruction_address);
      result += buffer;
    }
    result += "\n";
  }
  return result.c_str();
}


// PrintModulesMachineReadable outputs a list of loaded modules,
// one per line, in the following machine-readable pipe-delimited
// text format:
// Module|{Module Filename}|{Version}|{Debug Filename}|{Debug Identifier}|
// {Base Address}|{Max Address}|{Main}
static string PrintModulesMachineReadable(const CodeModules *modules) {

  string result = "";

  if (!modules)
    return result;

  uint64_t main_address = 0;
  const CodeModule *main_module = modules->GetMainModule();
  if (main_module) {
    main_address = main_module->base_address();
  }
  
  char buffer[1024];
  
  unsigned int module_count = modules->module_count();
  for (unsigned int module_sequence = 0;
       module_sequence < module_count;
       ++module_sequence) {
    const CodeModule *module = modules->GetModuleAtSequence(module_sequence);
    uint64_t base_address = module->base_address();
    sprintf(buffer,
	    "Module%c%s%c%s%c%s%c%s%c0x%08" PRIx64 "%c0x%08" PRIx64 "%c%d\n",
	    kOutputSeparator,
	    StripSeparator(PathnameStripper::File(module->code_file())).c_str(),
	    kOutputSeparator, StripSeparator(module->version()).c_str(),
	    kOutputSeparator,
	    StripSeparator(PathnameStripper::File(module->debug_file())).c_str(),
	    kOutputSeparator,
	    StripSeparator(module->debug_identifier()).c_str(),
	    kOutputSeparator, base_address,
	    kOutputSeparator, base_address + module->size() - 1,
	    kOutputSeparator,
	    main_module != NULL && base_address == main_address ? 1 : 0);
    result += buffer;
  }

  return result;
}

JNIEXPORT jstring JNICALL Java_com_avos_uluru_breakpad_BreakpadMinidumpStackwalker_getCrashStack (JNIEnv * env, jobject obj, jstring minidumpPath, jstring shareSymbolsPath, jstring appSymbolsPath) { 

  const char* minidump_file = env->GetStringUTFChars(minidumpPath, JNI_FALSE);
  const char* share_symbols_path = env->GetStringUTFChars(shareSymbolsPath, JNI_FALSE);
  const char* app_symbols_path = env->GetStringUTFChars(appSymbolsPath, JNI_FALSE);
 
  vector<string> symbol_paths;
  symbol_paths.push_back(share_symbols_path);
  symbol_paths.push_back(app_symbols_path);

  scoped_ptr<SimpleSymbolSupplier> symbol_supplier;
  symbol_supplier.reset(new SimpleSymbolSupplier(symbol_paths));

  BasicSourceLineResolver resolver;
  MinidumpProcessor minidump_processor(symbol_supplier.get(), &resolver);

  Minidump dump(minidump_file);
  if (!dump.Read()) {
     BPLOG(ERROR) << "Minidump " << dump.path() << " could not be read";
     return false;
  }

  ProcessState process_state;
  if (minidump_processor.Process(&dump, &process_state) !=
      google_breakpad::PROCESS_OK) {
    BPLOG(ERROR) << "MinidumpProcessor::Process failed";
    return false;
  }

  string result = "";
  char buffer[1024];

  // sprintf(buffer, "%s\n", process_state.crash_reason().c_str());

  // Print OS and CPU information.
  // OS|{OS Name}|{OS Version}
  // CPU|{CPU Name}|{CPU Info}|{Number of CPUs}
  sprintf(buffer, 
	  "OS%c%s%c%s\n", kOutputSeparator,
	  StripSeparator(process_state.system_info()->os).c_str(),
	  kOutputSeparator,
	  StripSeparator(process_state.system_info()->os_version).c_str());
  result += buffer;
  sprintf(buffer,
	  "CPU%c%s%c%s%c%d\n", kOutputSeparator,
	  StripSeparator(process_state.system_info()->cpu).c_str(),
	  kOutputSeparator,
	  // this may be empty
	  StripSeparator(process_state.system_info()->cpu_info).c_str(),
	  kOutputSeparator,
	  process_state.system_info()->cpu_count);

  result += buffer;

  int requesting_thread = process_state.requesting_thread();

  // Print crash information.
  // Crash|{Crash Reason}|{Crash Address}|{Crashed Thread}
  sprintf(buffer, "Crash%c", kOutputSeparator);
  result += buffer;
  if (process_state.crashed()) {
    sprintf(buffer,
	    "%s%c0x%" PRIx64 "%c",
	    StripSeparator(process_state.crash_reason()).c_str(),
	    kOutputSeparator, process_state.crash_address(), kOutputSeparator);
    result += buffer;
  } else {
    // print assertion info, if available, in place of crash reason,
    // instead of the unhelpful "No crash"
    string assertion = process_state.assertion();
    if (!assertion.empty()) {
      sprintf(buffer,
	      "%s%c%c", StripSeparator(assertion).c_str(),
	      kOutputSeparator, kOutputSeparator);
      result += buffer;
    } else {
      sprintf(buffer, "No crash%c%c", kOutputSeparator, kOutputSeparator);
      result += buffer;
    }
  }
  
  if (requesting_thread != -1) {
    sprintf(buffer, "%d\n", requesting_thread);
  } else {
    sprintf(buffer, "\n");
  }

  result += buffer;
  result += PrintModulesMachineReadable(process_state.modules());  
  result += "\n";

  if (requesting_thread != -1) {
    result += PrintStackMachineReadable(requesting_thread, process_state.threads()->at(requesting_thread));
  }

  // Print all of the threads in the dump.
  int thread_count = process_state.threads()->size();
  for (int thread_index = 0; thread_index < thread_count; ++thread_index) {
    if (thread_index != requesting_thread) {
      // Don't print the crash thread again, it was already printed.
      result += PrintStackMachineReadable(thread_index, process_state.threads()->at(thread_index));
    }
  }

  return env->NewStringUTF(result.c_str()); 
}

