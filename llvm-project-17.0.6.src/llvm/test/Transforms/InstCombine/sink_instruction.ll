; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

;; This tests that the instructions in the entry blocks are sunk into each
;; arm of the 'if'.

define i32 @test1(i1 %C, i32 %A, i32 %B) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[THEN:%.*]], label [[ENDIF:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[TMP_9:%.*]] = add i32 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    ret i32 [[TMP_9]]
; CHECK:       endif:
; CHECK-NEXT:    [[TMP_2:%.*]] = sdiv i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[TMP_2]]
;
entry:
  %tmp.2 = sdiv i32 %A, %B                ; <i32> [#uses=1]
  %tmp.9 = add i32 %B, %A         ; <i32> [#uses=1]
  br i1 %C, label %then, label %endif

then:           ; preds = %entry
  ret i32 %tmp.9

endif:          ; preds = %entry
  ret i32 %tmp.2
}


;; PHI use, sink divide before call.
define i32 @test2(i32 %x) nounwind ssp {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[X_ADDR_17:%.*]] = phi i32 [ [[X:%.*]], [[ENTRY:%.*]] ], [ [[X_ADDR_0:%.*]], [[BB2:%.*]] ]
; CHECK-NEXT:    [[I_06:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[TMP4:%.*]], [[BB2]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = icmp eq i32 [[X_ADDR_17]], 0
; CHECK-NEXT:    br i1 [[TMP0]], label [[BB1:%.*]], label [[BB2]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP1:%.*]] = add nsw i32 [[X_ADDR_17]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = sdiv i32 [[TMP1]], [[X_ADDR_17]]
; CHECK-NEXT:    [[TMP3:%.*]] = tail call i32 @bar() #[[ATTR3:[0-9]+]]
; CHECK-NEXT:    br label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    [[X_ADDR_0]] = phi i32 [ [[TMP2]], [[BB1]] ], [ [[X_ADDR_17]], [[BB]] ]
; CHECK-NEXT:    [[TMP4]] = add nuw nsw i32 [[I_06]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[TMP4]], 1000000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[BB4:%.*]], label [[BB]]
; CHECK:       bb4:
; CHECK-NEXT:    ret i32 [[X_ADDR_0]]
;
entry:
  br label %bb

bb:                                               ; preds = %bb2, %entry
  %x_addr.17 = phi i32 [ %x, %entry ], [ %x_addr.0, %bb2 ] ; <i32> [#uses=4]
  %i.06 = phi i32 [ 0, %entry ], [ %4, %bb2 ]     ; <i32> [#uses=1]
  %0 = add nsw i32 %x_addr.17, 1                  ; <i32> [#uses=1]
  %1 = sdiv i32 %0, %x_addr.17                    ; <i32> [#uses=1]
  %2 = icmp eq i32 %x_addr.17, 0                  ; <i1> [#uses=1]
  br i1 %2, label %bb1, label %bb2

bb1:                                              ; preds = %bb
  %3 = tail call i32 @bar() nounwind       ; <i32> [#uses=0]
  br label %bb2

bb2:                                              ; preds = %bb, %bb1
  %x_addr.0 = phi i32 [ %1, %bb1 ], [ %x_addr.17, %bb ] ; <i32> [#uses=2]
  %4 = add nsw i32 %i.06, 1                       ; <i32> [#uses=2]
  %exitcond = icmp eq i32 %4, 1000000             ; <i1> [#uses=1]
  br i1 %exitcond, label %bb4, label %bb

bb4:                                              ; preds = %bb2
  ret i32 %x_addr.0
}

declare i32 @bar()

define i32 @test3(ptr nocapture readonly %P, i32 %i) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[I:%.*]], label [[SW_EPILOG:%.*]] [
; CHECK-NEXT:    i32 5, label [[SW_BB:%.*]]
; CHECK-NEXT:    i32 2, label [[SW_BB]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i64 [[IDXPROM]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP0]], [[I]]
; CHECK-NEXT:    br label [[SW_EPILOG]]
; CHECK:       sw.epilog:
; CHECK-NEXT:    [[SUM_0:%.*]] = phi i32 [ [[ADD]], [[SW_BB]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 [[SUM_0]]
;
entry:
  %idxprom = sext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, ptr %P, i64 %idxprom
  %0 = load i32, ptr %arrayidx, align 4
  switch i32 %i, label %sw.epilog [
  i32 5, label %sw.bb
  i32 2, label %sw.bb
  ]

sw.bb:                                            ; preds = %entry, %entry
  %add = add nsw i32 %0, %i
  br label %sw.epilog

sw.epilog:                                        ; preds = %entry, %sw.bb
  %sum.0 = phi i32 [ %add, %sw.bb ], [ 0, %entry ]
  ret i32 %sum.0
}

declare i32 @foo(i32, i32)
; Two uses in a single user. We can still sink the instruction (tmp.9).
define i32 @test4(i32 %A, i32 %B, i1 %C) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[THEN:%.*]], label [[ENDIF:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[TMP_9:%.*]] = add i32 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = call i32 @foo(i32 [[TMP_9]], i32 [[TMP_9]])
; CHECK-NEXT:    ret i32 [[RES]]
; CHECK:       endif:
; CHECK-NEXT:    [[TMP_2:%.*]] = sdiv i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[TMP_2]]
;
entry:
  %tmp.2 = sdiv i32 %A, %B                ; <i32> [#uses=1]
  %tmp.9 = add i32 %B, %A         ; <i32> [#uses=1]
  br i1 %C, label %then, label %endif

then:           ; preds = %entry
  %res = call i32 @foo(i32  %tmp.9, i32 %tmp.9)
  ret i32 %res

endif:          ; preds = %entry
  ret i32 %tmp.2
}

; Two uses in a single user (phi node). We just bail out.
define i32 @test5(ptr nocapture readonly %P, i32 %i, i1 %cond) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[I:%.*]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i64 [[IDXPROM]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[ARRAYIDX]], align 4
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[DISPATCHBB:%.*]], label [[SW_EPILOG:%.*]]
; CHECK:       dispatchBB:
; CHECK-NEXT:    [[ADD:%.*]] = shl nsw i32 [[I]], 1
; CHECK-NEXT:    br label [[SW_EPILOG]]
; CHECK:       sw.bb:
; CHECK-NEXT:    br label [[SW_EPILOG]]
; CHECK:       sw.epilog:
; CHECK-NEXT:    [[SUM_0:%.*]] = phi i32 [ [[TMP0]], [[SW_BB:%.*]] ], [ [[ADD]], [[DISPATCHBB]] ], [ [[TMP0]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 [[SUM_0]]
;
entry:
  %idxprom = sext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, ptr %P, i64 %idxprom
  %0 = load i32, ptr %arrayidx, align 4
  br i1 %cond, label %dispatchBB, label %sw.epilog

dispatchBB:
  %add = add nsw i32 %i, %i
  br label %sw.epilog

sw.bb:                                            ; preds = %entry, %entry
  br label %sw.epilog

sw.epilog:                                        ; preds = %entry, %sw.bb
  %sum.0 = phi i32 [ %0, %sw.bb ], [ %add, %dispatchBB ], [ %0, %entry ]
  ret i32 %sum.0
}

; Multiple uses but from same BB. We can sink.
define i32 @test6(ptr nocapture readonly %P, i32 %i, i1 %cond) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = shl nsw i32 [[I:%.*]], 1
; CHECK-NEXT:    br label [[DISPATCHBB:%.*]]
; CHECK:       dispatchBB:
; CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i64 [[IDXPROM]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[ARRAYIDX]], align 4
; CHECK-NEXT:    switch i32 [[I]], label [[SW_BB:%.*]] [
; CHECK-NEXT:    i32 5, label [[SW_EPILOG:%.*]]
; CHECK-NEXT:    i32 2, label [[SW_EPILOG]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    br label [[SW_EPILOG]]
; CHECK:       sw.epilog:
; CHECK-NEXT:    [[SUM_0:%.*]] = phi i32 [ [[ADD]], [[SW_BB]] ], [ [[TMP0]], [[DISPATCHBB]] ], [ [[TMP0]], [[DISPATCHBB]] ]
; CHECK-NEXT:    ret i32 [[SUM_0]]
;
entry:
  %idxprom = sext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, ptr %P, i64 %idxprom
  %0 = load i32, ptr %arrayidx, align 4
  %add = add nsw i32 %i, %i
  br label %dispatchBB

dispatchBB:
  switch i32 %i, label %sw.bb [
  i32 5, label %sw.epilog
  i32 2, label %sw.epilog
  ]

sw.bb:                                            ; preds = %entry, %entry
  br label %sw.epilog

sw.epilog:                                        ; preds = %entry, %sw.bb
  %sum.0 = phi i32 [ %add, %sw.bb ], [ %0, %dispatchBB ], [ %0, %dispatchBB ]
  ret i32 %sum.0
}

declare void @checkd(double)
declare double @log(double) willreturn nounwind readnone
define void @test7(i1 %cond, double %d) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[A:%.*]] = call double @log(double [[D:%.*]])
; CHECK-NEXT:    call void @checkd(double [[A]])
; CHECK-NEXT:    ret void
; CHECK:       else:
; CHECK-NEXT:    ret void
;
  %A = call double @log(double %d)
  br i1 %cond, label %if, label %else

if:
  call void @checkd(double %A)
  ret void
else:
  ret void
}

declare void @abort()
declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64)
declare void @dummy(i64)
; Two uses in two different users of a single successor block. We can sink.
define i64 @test8(i64 %c) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    [[OVERFLOW:%.*]] = icmp ugt i64 [[C:%.*]], 2305843009213693951
; CHECK-NEXT:    br i1 [[OVERFLOW]], label [[ABORT:%.*]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @dummy(i64 8)
; CHECK-NEXT:    ret i64 8
; CHECK:       abort:
; CHECK-NEXT:    call void @abort()
; CHECK-NEXT:    unreachable
;
bb1:
  %mul = tail call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %c, i64 8)
  %overflow = extractvalue { i64, i1 } %mul, 1
  %select = select i1 %overflow, i64 0, i64 8
  br i1 %overflow, label %abort, label %bb2

bb2:
  call void @dummy(i64 %select)
  ret i64 %select

abort:
  call void @abort()
  unreachable
}