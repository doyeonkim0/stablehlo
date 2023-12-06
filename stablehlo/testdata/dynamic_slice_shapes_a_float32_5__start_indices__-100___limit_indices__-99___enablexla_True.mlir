// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<5xf32>, tensor<1xi32>)
    %1 = call @expected() : () -> tensor<1xf32>
    %2 = "stablehlo.slice"(%0#1) {limit_indices = array<i64: 1>, start_indices = array<i64: 0>, strides = array<i64: 1>} : (tensor<1xi32>) -> tensor<1xi32>
    %3 = stablehlo.reshape %2 : (tensor<1xi32>) -> tensor<i32>
    %4 = stablehlo.constant dense<0> : tensor<i32>
    %5 = stablehlo.compare  LT, %3, %4,  SIGNED : (tensor<i32>, tensor<i32>) -> tensor<i1>
    %6 = stablehlo.constant dense<5> : tensor<i32>
    %7 = stablehlo.add %3, %6 : tensor<i32>
    %8 = stablehlo.select %5, %7, %3 : tensor<i1>, tensor<i32>
    %9 = stablehlo.dynamic_slice %0#0, %8, sizes = [1] : (tensor<5xf32>, tensor<i32>) -> tensor<1xf32>
    %10 = stablehlo.custom_call @check.eq(%9, %1) : (tensor<1xf32>, tensor<1xf32>) -> tensor<i1>
    return %10 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5xf32>, tensor<1xi32>) {
    %0 = stablehlo.constant dense<[1.23439837, -0.210324734, -5.17375469, 2.24041915, -4.9496727]> : tensor<5xf32>
    %1 = stablehlo.constant dense<-100> : tensor<1xi32>
    return %0, %1 : tensor<5xf32>, tensor<1xi32>
  }
  func.func private @expected() -> tensor<1xf32> {
    %0 = stablehlo.constant dense<1.23439837> : tensor<1xf32>
    return %0 : tensor<1xf32>
  }
}
