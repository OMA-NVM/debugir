; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+v8.2a,+fullfp16 -fp-contract=fast -verify-machineinstrs -global-isel=0 | FileCheck %s
;RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+v8.2a,+fullfp16 -verify-machineinstrs -global-isel=0 | FileCheck %s


define half @fnmul16(half noundef %x, half noundef %y)  {
; CHECK-LABEL: fnmul16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fnmul h0, h0, h1
; CHECK-NEXT:    ret
;
entry:
  %fneg = fneg fast half %x
  %mul = fmul fast half %fneg, %y
  ret half %mul
}

define float @fnmul32(float noundef %x, float noundef %y)  {
; CHECK-LABEL: fnmul32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fnmul s0, s0, s1
; CHECK-NEXT:    ret
;
entry:
  %fneg = fneg float %x
  %mul = fmul float %fneg, %y
  ret float %mul
}

define double @fnmul64(double noundef %x, double noundef %y)  {
; CHECK-LABEL: fnmul64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fnmul d0, d0, d1
; CHECK-NEXT:    ret
;
entry:
  %fneg = fneg fast double %x
  %mul = fmul fast double %fneg, %y
  ret double %mul
}

define half @fnmul16_2(half noundef %x, half noundef %y)  {
; CHECK-LABEL: fnmul16_2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fnmul h0, h1, h0
; CHECK-NEXT:    ret
;
entry:
  %fneg = fneg fast half %y
  %mul = fmul fast half %x, %fneg
  ret half %mul
}

define float @fnmul32_2(float noundef %x, float noundef %y)  {
; CHECK-LABEL: fnmul32_2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fnmul s0, s1, s0
; CHECK-NEXT:    ret
;
entry:
  %fneg = fneg fast float %y
  %mul = fmul fast float %x, %fneg
  ret float %mul
}

define double @fnmul64_2(double noundef %x, double noundef %y)  {
; CHECK-LABEL: fnmul64_2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fnmul d0, d1, d0
; CHECK-NEXT:    ret
;
entry:
  %fneg = fneg double %y
  %mul = fmul double %x, %fneg
  ret double %mul
}