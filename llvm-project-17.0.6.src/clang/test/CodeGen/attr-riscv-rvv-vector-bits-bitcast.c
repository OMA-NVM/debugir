// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple riscv64-none-linux-gnu -target-feature +f -target-feature +d -target-feature +zve64d -mvscale-min=1 -mvscale-max=1 -S -O1 -emit-llvm -o - %s | FileCheck %s --check-prefix=CHECK-64
// RUN: %clang_cc1 -triple riscv64-none-linux-gnu -target-feature +f -target-feature +d -target-feature +zve64d -mvscale-min=2 -mvscale-max=2 -S -O1 -emit-llvm -o - %s | FileCheck %s --check-prefix=CHECK-128
// RUN: %clang_cc1 -triple riscv64-none-linux-gnu -target-feature +f -target-feature +d -target-feature +zve64d -mvscale-min=4 -mvscale-max=4 -S -O1 -emit-llvm -o - %s | FileCheck %s --check-prefix=CHECK-256

// REQUIRES: riscv-registered-target

#include <stdint.h>

typedef __rvv_int8m1_t vint8m1_t;
typedef __rvv_uint8m1_t vuint8m1_t;
typedef __rvv_int16m1_t vint16m1_t;
typedef __rvv_uint16m1_t vuint16m1_t;
typedef __rvv_int32m1_t vint32m1_t;
typedef __rvv_uint32m1_t vuint32m1_t;
typedef __rvv_int64m1_t vint64m1_t;
typedef __rvv_uint64m1_t vuint64m1_t;
typedef __rvv_float32m1_t vfloat32m1_t;
typedef __rvv_float64m1_t vfloat64m1_t;

typedef vint64m1_t fixed_int64m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));
typedef vfloat64m1_t fixed_float64m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));

#define DEFINE_STRUCT(ty)   \
  struct struct_##ty {      \
    fixed_##ty##_t x, y[3]; \
  } struct_##ty;

DEFINE_STRUCT(int64m1)
DEFINE_STRUCT(float64m1)

//===----------------------------------------------------------------------===//
// int64
//===----------------------------------------------------------------------===//

// CHECK-64-LABEL: @read_int64m1(
// CHECK-64-NEXT:  entry:
// CHECK-64-NEXT:    [[Y:%.*]] = getelementptr inbounds [[STRUCT_STRUCT_INT64M1:%.*]], ptr [[S:%.*]], i64 0, i32 1
// CHECK-64-NEXT:    [[TMP0:%.*]] = load <1 x i64>, ptr [[Y]], align 8, !tbaa [[TBAA4:![0-9]+]]
// CHECK-64-NEXT:    [[CASTSCALABLESVE:%.*]] = tail call <vscale x 1 x i64> @llvm.vector.insert.nxv1i64.v1i64(<vscale x 1 x i64> undef, <1 x i64> [[TMP0]], i64 0)
// CHECK-64-NEXT:    ret <vscale x 1 x i64> [[CASTSCALABLESVE]]
//
// CHECK-128-LABEL: @read_int64m1(
// CHECK-128-NEXT:  entry:
// CHECK-128-NEXT:    [[Y:%.*]] = getelementptr inbounds [[STRUCT_STRUCT_INT64M1:%.*]], ptr [[S:%.*]], i64 0, i32 1
// CHECK-128-NEXT:    [[TMP0:%.*]] = load <2 x i64>, ptr [[Y]], align 8, !tbaa [[TBAA4:![0-9]+]]
// CHECK-128-NEXT:    [[CASTSCALABLESVE:%.*]] = tail call <vscale x 1 x i64> @llvm.vector.insert.nxv1i64.v2i64(<vscale x 1 x i64> undef, <2 x i64> [[TMP0]], i64 0)
// CHECK-128-NEXT:    ret <vscale x 1 x i64> [[CASTSCALABLESVE]]
//
// CHECK-256-LABEL: @read_int64m1(
// CHECK-256-NEXT:  entry:
// CHECK-256-NEXT:    [[Y:%.*]] = getelementptr inbounds [[STRUCT_STRUCT_INT64M1:%.*]], ptr [[S:%.*]], i64 0, i32 1
// CHECK-256-NEXT:    [[TMP0:%.*]] = load <4 x i64>, ptr [[Y]], align 8, !tbaa [[TBAA4:![0-9]+]]
// CHECK-256-NEXT:    [[CASTSCALABLESVE:%.*]] = tail call <vscale x 1 x i64> @llvm.vector.insert.nxv1i64.v4i64(<vscale x 1 x i64> undef, <4 x i64> [[TMP0]], i64 0)
// CHECK-256-NEXT:    ret <vscale x 1 x i64> [[CASTSCALABLESVE]]
//
vint64m1_t read_int64m1(struct struct_int64m1 *s) {
  return s->y[0];
}

// CHECK-64-LABEL: @write_int64m1(
// CHECK-64-NEXT:  entry:
// CHECK-64-NEXT:    [[CASTFIXEDSVE:%.*]] = tail call <1 x i64> @llvm.vector.extract.v1i64.nxv1i64(<vscale x 1 x i64> [[X:%.*]], i64 0)
// CHECK-64-NEXT:    [[Y:%.*]] = getelementptr inbounds [[STRUCT_STRUCT_INT64M1:%.*]], ptr [[S:%.*]], i64 0, i32 1
// CHECK-64-NEXT:    store <1 x i64> [[CASTFIXEDSVE]], ptr [[Y]], align 8, !tbaa [[TBAA4]]
// CHECK-64-NEXT:    ret void
//
// CHECK-128-LABEL: @write_int64m1(
// CHECK-128-NEXT:  entry:
// CHECK-128-NEXT:    [[CASTFIXEDSVE:%.*]] = tail call <2 x i64> @llvm.vector.extract.v2i64.nxv1i64(<vscale x 1 x i64> [[X:%.*]], i64 0)
// CHECK-128-NEXT:    [[Y:%.*]] = getelementptr inbounds [[STRUCT_STRUCT_INT64M1:%.*]], ptr [[S:%.*]], i64 0, i32 1
// CHECK-128-NEXT:    store <2 x i64> [[CASTFIXEDSVE]], ptr [[Y]], align 8, !tbaa [[TBAA4]]
// CHECK-128-NEXT:    ret void
//
// CHECK-256-LABEL: @write_int64m1(
// CHECK-256-NEXT:  entry:
// CHECK-256-NEXT:    [[CASTFIXEDSVE:%.*]] = tail call <4 x i64> @llvm.vector.extract.v4i64.nxv1i64(<vscale x 1 x i64> [[X:%.*]], i64 0)
// CHECK-256-NEXT:    [[Y:%.*]] = getelementptr inbounds [[STRUCT_STRUCT_INT64M1:%.*]], ptr [[S:%.*]], i64 0, i32 1
// CHECK-256-NEXT:    store <4 x i64> [[CASTFIXEDSVE]], ptr [[Y]], align 8, !tbaa [[TBAA4]]
// CHECK-256-NEXT:    ret void
//
void write_int64m1(struct struct_int64m1 *s, vint64m1_t x) {
  s->y[0] = x;
}

//===----------------------------------------------------------------------===//
// float64
//===----------------------------------------------------------------------===//

// CHECK-64-LABEL: @read_float64m1(
// CHECK-64-NEXT:  entry:
// CHECK-64-NEXT:    [[Y:%.*]] = getelementptr inbounds [[STRUCT_STRUCT_FLOAT64M1:%.*]], ptr [[S:%.*]], i64 0, i32 1
// CHECK-64-NEXT:    [[TMP0:%.*]] = load <1 x double>, ptr [[Y]], align 8, !tbaa [[TBAA4]]
// CHECK-64-NEXT:    [[CASTSCALABLESVE:%.*]] = tail call <vscale x 1 x double> @llvm.vector.insert.nxv1f64.v1f64(<vscale x 1 x double> undef, <1 x double> [[TMP0]], i64 0)
// CHECK-64-NEXT:    ret <vscale x 1 x double> [[CASTSCALABLESVE]]
//
// CHECK-128-LABEL: @read_float64m1(
// CHECK-128-NEXT:  entry:
// CHECK-128-NEXT:    [[Y:%.*]] = getelementptr inbounds [[STRUCT_STRUCT_FLOAT64M1:%.*]], ptr [[S:%.*]], i64 0, i32 1
// CHECK-128-NEXT:    [[TMP0:%.*]] = load <2 x double>, ptr [[Y]], align 8, !tbaa [[TBAA4]]
// CHECK-128-NEXT:    [[CASTSCALABLESVE:%.*]] = tail call <vscale x 1 x double> @llvm.vector.insert.nxv1f64.v2f64(<vscale x 1 x double> undef, <2 x double> [[TMP0]], i64 0)
// CHECK-128-NEXT:    ret <vscale x 1 x double> [[CASTSCALABLESVE]]
//
// CHECK-256-LABEL: @read_float64m1(
// CHECK-256-NEXT:  entry:
// CHECK-256-NEXT:    [[Y:%.*]] = getelementptr inbounds [[STRUCT_STRUCT_FLOAT64M1:%.*]], ptr [[S:%.*]], i64 0, i32 1
// CHECK-256-NEXT:    [[TMP0:%.*]] = load <4 x double>, ptr [[Y]], align 8, !tbaa [[TBAA4]]
// CHECK-256-NEXT:    [[CASTSCALABLESVE:%.*]] = tail call <vscale x 1 x double> @llvm.vector.insert.nxv1f64.v4f64(<vscale x 1 x double> undef, <4 x double> [[TMP0]], i64 0)
// CHECK-256-NEXT:    ret <vscale x 1 x double> [[CASTSCALABLESVE]]
//
vfloat64m1_t read_float64m1(struct struct_float64m1 *s) {
  return s->y[0];
}

// CHECK-64-LABEL: @write_float64m1(
// CHECK-64-NEXT:  entry:
// CHECK-64-NEXT:    [[CASTFIXEDSVE:%.*]] = tail call <1 x double> @llvm.vector.extract.v1f64.nxv1f64(<vscale x 1 x double> [[X:%.*]], i64 0)
// CHECK-64-NEXT:    [[Y:%.*]] = getelementptr inbounds [[STRUCT_STRUCT_FLOAT64M1:%.*]], ptr [[S:%.*]], i64 0, i32 1
// CHECK-64-NEXT:    store <1 x double> [[CASTFIXEDSVE]], ptr [[Y]], align 8, !tbaa [[TBAA4]]
// CHECK-64-NEXT:    ret void
//
// CHECK-128-LABEL: @write_float64m1(
// CHECK-128-NEXT:  entry:
// CHECK-128-NEXT:    [[CASTFIXEDSVE:%.*]] = tail call <2 x double> @llvm.vector.extract.v2f64.nxv1f64(<vscale x 1 x double> [[X:%.*]], i64 0)
// CHECK-128-NEXT:    [[Y:%.*]] = getelementptr inbounds [[STRUCT_STRUCT_FLOAT64M1:%.*]], ptr [[S:%.*]], i64 0, i32 1
// CHECK-128-NEXT:    store <2 x double> [[CASTFIXEDSVE]], ptr [[Y]], align 8, !tbaa [[TBAA4]]
// CHECK-128-NEXT:    ret void
//
// CHECK-256-LABEL: @write_float64m1(
// CHECK-256-NEXT:  entry:
// CHECK-256-NEXT:    [[CASTFIXEDSVE:%.*]] = tail call <4 x double> @llvm.vector.extract.v4f64.nxv1f64(<vscale x 1 x double> [[X:%.*]], i64 0)
// CHECK-256-NEXT:    [[Y:%.*]] = getelementptr inbounds [[STRUCT_STRUCT_FLOAT64M1:%.*]], ptr [[S:%.*]], i64 0, i32 1
// CHECK-256-NEXT:    store <4 x double> [[CASTFIXEDSVE]], ptr [[Y]], align 8, !tbaa [[TBAA4]]
// CHECK-256-NEXT:    ret void
//
void write_float64m1(struct struct_float64m1 *s, vfloat64m1_t x) {
  s->y[0] = x;
}