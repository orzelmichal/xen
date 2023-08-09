### Set 1 ###

#
# Series 2.
#

-doc_begin="The compiler implementation guarantees that the unreachable code is removed.
Constant expressions and unreachable branches of if and switch statements are expected."
-config=MC3R1.R2.1,+reports={safe,"first_area(^.*has an invariantly.*$)"}
-config=MC3R1.R2.1,+reports={safe,"first_area(^.*incompatible with labeled statement$)"}
-doc_end

-doc_begin="Some functions are intended to be not referenced."
-config=MC3R1.R2.1,+reports={deliberate,"first_area(^.*is never referenced$)"}
-doc_end

-doc_begin="Unreachability caused by calls to the following functions or macros is deliberate and there is no risk of code being unexpectedly left out."
-config=MC3R1.R2.1,statements+={deliberate,"macro(name(BUG||assert_failed||ERROR_EXIT||ERROR_EXIT_DOM||PIN_FAIL))"}
-config=MC3R1.R2.1,statements+={deliberate, "call(decl(name(__builtin_unreachable||panic||do_unexpected_trap||machine_halt||machine_restart||maybe_reboot)))"}
-doc_end

-doc_begin="Unreachability of an ASSERT_UNREACHABLE() and analogous macro calls is deliberate and safe."
-config=MC3R1.R2.1,reports+={deliberate, "any_area(any_loc(any_exp(macro(name(ASSERT_UNREACHABLE||PARSE_ERR_RET||PARSE_ERR||FAIL_MSR||FAIL_CPUID)))))"}
-doc_end

-doc_begin="Proving compliance with respect to Rule 2.2 is generally impossible:
see https://arxiv.org/abs/2212.13933 for details. Moreover, peer review gives us
confidence that no evidence of errors in the program's logic has been missed due
to undetected violations of Rule 2.2, if any. Testing on time behavior gives us
confidence on the fact that, should the program contain dead code that is not
removed by the compiler, the resulting slowdown is negligible."
-config=MC3R1.R2.2,reports+={disapplied,"any()"}
-doc_end

#
# Series 3.
#

-doc_begin="Comments starting with '/*' and containing hyperlinks are safe as
they are not instances of commented-out code."
-config=MC3R1.R3.1,reports+={safe, "first_area(text(^.*https?://.*$))"}
-doc_end

#
# Series 4.
#

-doc_begin="The directive has been accepted only for the ARM codebase."
-config=MC3R1.D4.3,reports+={disapplied,"!(any_area(any_loc(file(^xen/arch/arm/arm64/.*$))))"}
-doc_end

-doc_begin="Depending on the compiler, rewriting the following function-like
macros as inline functions is not guaranteed to have the same effect."
-config=MC3R1.D4.9,macros+={deliberate,"name(likely)"}
-config=MC3R1.D4.9,macros+={deliberate,"name(unlikely)"}
-config=MC3R1.D4.9,macros+={deliberate,"name(unreachable)"}
-doc_end

-doc_begin="These macros can be used on both pointers and unsigned long type values."
-config=MC3R1.D4.9,macros+={safe,"name(virt_to_maddr)"}
-config=MC3R1.D4.9,macros+={safe,"name(virt_to_mfn)"}
-doc_end

-doc_begin="Rewriting variadic macros as variadic functions might have a negative impact on safety."
-config=MC3R1.D4.9,macros+={deliberate,"variadic()"}
-doc_end

-doc_begin="Rewriting macros with arguments that are, in turn, arguments of
__builtin_constant_p() can change the behavior depending on the optimization
level."
-config=MC3R1.D4.9,macro_argument_context+="skip_to(class(type||expr||decl,any),
                                            call(name(__builtin_constant_p)))"
-doc_end

-doc_begin="Function-like macros defined in public headers are meant to be
usable in C89 mode without any extensions. Hence they cannot be replaced by
inline functions."
-config=MC3R1.D4.9,macros+={deliberate, "loc(file(api:public))"}
-doc_end

-doc_begin="This header file is autogenerated or empty, therefore it poses no
risk if included more than once."
-file_tag+={empty_header, "^xen/arch/arm/efi/runtime\\.h$"}
-file_tag+={autogen_headers, "^xen/include/xen/compile\\.h$||^xen/include/generated/autoconf.h$||^xen/include/xen/hypercall-defs.h$"}
-config=MC3R1.D4.10,reports+={safe, "all_area(all_loc(file(empty_header||autogen_headers)))"}
-doc_end

-doc_begin="Files that are intended to be included more than once do not need to
conform to the directive."
-config=MC3R1.D4.10,reports+={safe, "first_area(text(^/\\* This file is legitimately included multiple times\\. \\*/$, begin-4))"}
-config=MC3R1.D4.10,reports+={safe, "first_area(text(^/\\* Generated file, do not edit! \\*/$, begin-3))"}
-doc_end

#
# Series 5.
#

-doc_begin="The project adopted the rule with an exception listed in
'docs/misra/rules.rst'"
-config=MC3R1.R5.3,reports+={safe, "any_area(any_loc(any_exp(macro(^READ_SYSREG$))&&any_exp(macro(^WRITE_SYSREG$))))"}
-config=MC3R1.R5.3,reports+={safe, "any_area(any_loc(any_exp(macro(^max(_t)?$))&&any_exp(macro(^min(_t)?$))))"}
-config=MC3R1.R5.3,reports+={safe, "any_area(any_loc(any_exp(macro(^read[bwlq]$))&&any_exp(macro(^read[bwlq]_relaxed$))))"}
-config=MC3R1.R5.3,reports+={safe, "any_area(any_loc(any_exp(macro(^per_cpu$))&&any_exp(macro(^this_cpu$))))"}
-config=MC3R1.R5.3,reports+={safe, "any_area(any_loc(any_exp(macro(^__emulate_2op$))&&any_exp(macro(^__emulate_2op_nobyte$))))"}
-config=MC3R1.R5.3,reports+={safe, "any_area(any_loc(any_exp(macro(^read_debugreg$))&&any_exp(macro(^write_debugreg$))))"}
-doc_end

-doc_begin="Function-like macros cannot be confused with identifiers that are
neither functions nor pointers to functions."
-config=MC3R1.R5.5,reports={safe,"all_area(decl(node(enum_decl||record_decl||field_decl||param_decl||var_decl)&&!type(canonical(address((node(function||function_no_proto))))))||macro(function_like()))"}
-doc_end

-doc_begin="The use of these identifiers for both macro names and other entities
is deliberate and does not generate developer confusion."
-config=MC3R1.R5.5,reports+={safe, "any_area(text(^\\s*/\\*\\s+SAF-[0-9]+-safe\\s+MC3R1\\.R5\\.5.*$, begin-1))"}
-doc_end

-doc_begin="The definition of macros and functions ending in '_bit' that use the
same identifier in 'bitops.h' is deliberate and safe."
-file_tag+={bitops_h, "^xen/arch/x86/include/asm/bitops\\.h$"}
-config=MC3R1.R5.5,reports+={safe, "all_area((decl(^.*_bit\\(.*$)||macro(^.*_bit$))&&all_loc(file(bitops_h)))"}
-doc_end

-doc_begin="The definition of macros and functions beginning in 'str' or 'mem'
that use the same identifier in 'xen/include/xen/string.h' is deliberate and
safe."
-file_tag+={string_h, "^xen/include/xen/string\\.h$"}
-config=MC3R1.R5.5,reports+={safe, "any_area((decl(^(mem|str).*$)||macro(^(mem|str).*$))&&all_loc(file(string_h)))"}
-doc_end

#
# Series 7.
#

-doc_begin="Usage of the following constants is safe, since they are given as-is
in the inflate algorithm specification and there is therefore no risk of them
being interpreted as decimal constants."
-config=MC3R1.R7.1,literals={safe, "^0(007|37|070|213|236|300|321|330|331|332|333|334|335|337|371)$"}
-doc_end

-doc_begin="Violations in files that maintainers have asked to not modify in the
context of R7.2."
-file_tag+={adopted_r7_2,"^xen/include/xen/libfdt/.*$"}
-file_tag+={adopted_r7_2,"^xen/arch/x86/include/asm/x86_64/efibind.h$"}
-file_tag+={adopted_r7_2,"^xen/include/efi/efiapi\\.h$"}
-file_tag+={adopted_r7_2,"^xen/include/efi/efidef\\.h$"}
-file_tag+={adopted_r7_2,"^xen/include/efi/efiprot\\.h$"}
-file_tag+={adopted_r7_2,"^xen/arch/x86/cpu/intel\\.c$"}
-file_tag+={adopted_r7_2,"^xen/arch/x86/cpu/amd\\.c$"}
-file_tag+={adopted_r7_2,"^xen/arch/x86/cpu/common\\.c$"}
-config=MC3R1.R7.2,reports+={deliberate,"any_area(any_loc(file(adopted_r7_2)))"}
-doc_end

-doc_begin="Violations caused by __HYPERVISOR_VIRT_START are related to the
particular use of it done in xen_mk_ulong."
-config=MC3R1.R7.2,reports+={deliberate,"any_area(any_loc(macro(name(BUILD_BUG_ON))))"}
-doc_end

-doc_begin="The following string literals are assigned to pointers to non
const-qualified char."
-config=MC3R1.R7.4,reports+={safe, "any_area(text(^\\s*/\\*\\s+SAF-[0-9]+-safe\\s+MC3R1\\.R7\\.4.*$, begin-1))"}
-doc_end

-doc_begin="Allow pointers of non-character type as long as the pointee is
const-qualified."
-config=MC3R1.R7.4,same_pointee=false
-doc_end

#
# Series 8.
#

-doc_begin="The following file is imported from Linux: ignore for now."
-file_tag+={adopted_r8_2,"^xen/common/inflate\\.c$"}
-config=MC3R1.R8.2,reports+={deliberate,"any_area(any_loc(file(adopted_r8_2)))"}
-doc_end

-doc_begin="The following variables are compiled in multiple translation units
belonging to different executables and therefore are safe."
-config=MC3R1.R8.6,declarations+={safe, "name(current_stack_pointer||bsearch||sort)"}
-doc_end

-doc_begin="Declarations without definitions are allowed (specifically when the
definition is compiled-out or optimized-out by the compiler)"
-config=MC3R1.R8.6,reports+={deliberate, "first_area(^.*has no definition$)"}
-doc_end

-doc_begin="The gnu_inline attribute without static is deliberately allowed."
-config=MC3R1.R8.10,declarations+={deliberate,"property(gnu_inline)"}
-doc_end

#
# Series 9.
#

-doc_begin="The following variables are written before being set, therefore no
access to uninitialized memory locations happens, as explained in the deviation
comment."
-config=MC3R1.R9.1,reports+={safe, "any_area(text(^\\s*/\\*\\s+SAF-[0-9]+-safe\\s+MC3R1\\.R9\\.1.*$, begin-1))"}
-doc_end

-doc_begin="Violations in files that maintainers have asked to not modify in the
context of R9.1."
-file_tag+={adopted_r9_1,"^xen/arch/arm/arm64/lib/find_next_bit\\.c$"}
-config=MC3R1.R9.1,reports+={deliberate,"any_area(any_loc(file(adopted_r9_1)))"}
-doc_end

-doc_begin="The possibility of committing mistakes by specifying an explicit
dimension is higher than omitting the dimension."
-config=MC3R1.R9.5,reports+={deliberate, "any()"}
-doc_end

### Set 2 ###

#
# Series 10.
#

-doc_begin="The value-preserving conversions of integer constants are safe"
-config=MC3R1.R10.1,etypes={safe,"any()","preserved_integer_constant()"}
-config=MC3R1.R10.3,etypes={safe,"any()","preserved_integer_constant()"}
-config=MC3R1.R10.4,etypes={safe,"any()","preserved_integer_constant()||sibling(rhs,preserved_integer_constant())"}
-doc_end

-doc_begin="Shifting non-negative integers to the right is safe."
-config=MC3R1.R10.1,etypes+={safe,
  "stmt(node(binary_operator)&&operator(shr))",
  "src_expr(definitely_in(0..))"}
-doc_end

-doc_begin="Shifting non-negative integers to the left is safe if the result is
still non-negative."
-config=MC3R1.R10.1,etypes+={safe,
  "stmt(node(binary_operator)&&operator(shl)&&definitely_in(0..))",
  "src_expr(definitely_in(0..))"}
-doc_end

-doc_begin="Bitwise logical operations on non-negative integers are safe."
-config=MC3R1.R10.1,etypes+={safe,
  "stmt(node(binary_operator)&&operator(and||or||xor))",
  "src_expr(definitely_in(0..))"}
-doc_end

-doc_begin="The implicit conversion to Boolean for logical operator arguments is well known to all Xen developers to be a comparison with 0"
-config=MC3R1.R10.1,etypes+={safe, "stmt(operator(logical)||node(conditional_operator||binary_conditional_operator))", "dst_type(ebool||boolean)"}
-doc_end

### Set 3 ###

#
# Series 18.
#

-doc_begin="FIXME: explain why pointer differences involving this macro are safe."
-config=MC3R1.R18.2,reports+={safe,"all_area(all_loc(any_exp(macro(^ACPI_PTR_DIFF$))))"}
-doc_end

-doc_begin="FIXME: explain why pointer differences involving this macro are safe."
-config=MC3R1.R18.2,reports+={safe,"all_area(all_loc(any_exp(macro(^page_to_mfn$))))"}
-doc_end

-doc_begin="FIXME: explain why pointer differences involving this macro are safe."
-config=MC3R1.R18.2,reports+={safe,"all_area(all_loc(any_exp(macro(^page_to_pdx$))))"}
-doc_end

#
# Series 20.
#

-doc_begin="Code violating Rule 20.7 is safe when macro parameters are used: (1)
as function arguments; (2) as macro arguments; (3) as array indices; (4) as lhs
in assignments."
-config=MC3R1.R20.7,expansion_context=
{safe, "context(__call_expr_arg_contexts)"},
{safe, "context(skip_to(__expr_non_syntactic_contexts, stmt_child(node(array_subscript_expr), subscript)))"},
{safe, "context(skip_to(__expr_non_syntactic_contexts, stmt_child(operator(assign), lhs)))"},
{safe, "left_right(^[(,\\[]$,^[),\\]]$)"}
-doc_end

#
# Developer confusion
#

-doc="Selection for reports that are fully contained in adopted code."
-report_selector+={adopted_report,"all_area(!kind(culprit||evidence)||all_loc(all_exp(adopted||pseudo)))"}

-doc_begin="Adopted code is not meant to be read, reviewed or modified by human
programmers:no developers' confusion is not possible. In addition, adopted code
is assumed to work as is. Reports that are fully contained in adopted code are
hidden/tagged with the 'adopted' tag."
-service_selector={developer_confusion_guidelines,"^(MC3R1\\.R2\\.1|MC3R1\\.R2\\.2|MC3R1\\.R2\\.3|MC3R1\\.R2\\.4|MC3R1\\.R2\\.5|MC3R1\\.R2\\.6|MC3R1\\.R2\\.7|MC3R1\\.R4\\.1|MC3R1\\.R5\\.3|MC3R1\\.R5\\.6|MC3R1\\.R5\\.7|MC3R1\\.R5\\.8|MC3R1\\.R5\\.9|MC3R1\\.R7\\.1|MC3R1\\.R7\\.2|MC3R1\\.R7\\.3|MC3R1\\.R8\\.7|MC3R1\\.R8\\.8|MC3R1\\.R8\\.9|MC3R1\\.R8\\.11|MC3R1\\.R8\\.12|MC3R1\\.R8\\.13|MC3R1\\.R9\\.3|MC3R1\\.R9\\.4|MC3R1\\.R9\\.5|MC3R1\\.R10\\.2|MC3R1\\.R10\\.5|MC3R1\\.R10\\.6|MC3R1\\.R10\\.7|MC3R1\\.R10\\.8|MC3R1\\.R11\\.9|MC3R1\\.R12\\.1|MC3R1\\.R12\\.3|MC3R1\\.R12\\.4|MC3R1\\.R13\\.5|MC3R1\\.R14\\.1|MC3R1\\.R14\\.2|MC3R1\\.R14\\.3|MC3R1\\.R15\\.1|MC3R1\\.R15\\.2|MC3R1\\.R15\\.3|MC3R1\\.R15\\.4|MC3R1\\.R15\\.5|MC3R1\\.R15\\.6|MC3R1\\.R15\\.7|MC3R1\\.R16\\.1|MC3R1\\.R16\\.2|MC3R1\\.R16\\.3|MC3R1\\.R16\\.4|MC3R1\\.R16\\.5|MC3R1\\.R16\\.6|MC3R1\\.R16\\.7|MC3R1\\.R17\\.7|MC3R1\\.R17\\.8|MC3R1\\.R18\\.4|MC3R1\\.R18\\.5)$"
}
-config=developer_confusion_guidelines,reports+={relied,adopted_report}
-doc_end
