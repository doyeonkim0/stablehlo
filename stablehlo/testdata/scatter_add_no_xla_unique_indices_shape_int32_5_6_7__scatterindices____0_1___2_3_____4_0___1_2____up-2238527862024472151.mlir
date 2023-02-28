module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<5x2x2xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {indices_are_sorted = false, scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2x2xi32>, tensor<5x2x2xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<5x2x2xi32>) {
    %0 = stablehlo.constant dense<"0xFDFFFFFFFFFFFFFF02000000FBFFFFFFFFFFFFFF0100000002000000FDFFFFFFFEFFFFFF000000000000000000000000050000000100000001000000FFFFFFFF00000000040000000200000000000000FFFFFFFFFEFFFFFFFFFFFFFF0100000001000000FEFFFFFF0000000004000000040000000000000001000000000000000100000003000000FCFFFFFFFDFFFFFF0600000000000000FFFFFFFF03000000000000000600000001000000040000000300000001000000FEFFFFFF040000000200000007000000FBFFFFFFFCFFFFFFFFFFFFFF0100000001000000FDFFFFFF00000000FFFFFFFFFFFFFFFFFDFFFFFF04000000FFFFFFFF0200000001000000FFFFFFFF0000000000000000FFFFFFFF040000000300000000000000000000000300000000000000000000000100000000000000000000000400000000000000FDFFFFFF00000000FAFFFFFF0100000000000000FAFFFFFFFEFFFFFF05000000010000000000000002000000FCFFFFFFFBFFFFFFFFFFFFFF01000000000000000600000000000000FDFFFFFF00000000FEFFFFFFFDFFFFFFFFFFFFFF00000000020000000400000001000000010000000000000005000000FFFFFFFF0500000000000000FFFFFFFF00000000FDFFFFFF0200000001000000FFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0200000000000000FFFFFFFFFDFFFFFFF9FFFFFF0100000003000000FCFFFFFF000000000100000000000000FDFFFFFF02000000FDFFFFFF00000000000000000000000003000000FFFFFFFFFFFFFFFF01000000FBFFFFFF010000000300000001000000FCFFFFFF000000000000000001000000FFFFFFFF02000000FEFFFFFF0000000000000000FDFFFFFF0000000000000000050000000200000000000000FFFFFFFF0000000000000000FFFFFFFF07000000FCFFFFFF00000000FFFFFFFFFCFFFFFF0100000001000000FEFFFFFF02000000FFFFFFFF05000000FFFFFFFFFFFFFFFF01000000FFFFFFFF00000000FFFFFFFFFEFFFFFF000000000500000004000000FEFFFFFF0200000002000000000000000000000000000000000000000000000001000000FEFFFFFF01000000FFFFFFFF02000000000000000000000000000000FEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFF00000000"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<[[[2, 1], [1, 3]], [[2, 4], [-5, 0]], [[2, 4], [5, 0]], [[4, 0], [7, -1]], [[0, 0], [3, 5]]]> : tensor<5x2x2xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<5x2x2xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0xFDFFFFFF0100000002000000FBFFFFFFFFFFFFFF0100000002000000FDFFFFFFFEFFFFFF030000000000000000000000050000000100000001000000FFFFFFFF00000000050000000200000000000000FFFFFFFFFEFFFFFFFFFFFFFF0100000001000000FEFFFFFF0000000004000000050000000000000001000000000000000100000003000000FCFFFFFFFDFFFFFF0600000000000000FFFFFFFF03000000000000000600000001000000060000000300000001000000FEFFFFFF040000000200000007000000FBFFFFFFFCFFFFFFFFFFFFFF0100000001000000FDFFFFFF00000000FFFFFFFFFFFFFFFF0100000004000000FFFFFFFF0200000001000000FFFFFFFF0000000000000000FFFFFFFF0400000003000000FBFFFFFF000000000300000000000000000000000100000000000000000000000400000000000000FDFFFFFF00000000FAFFFFFF0100000000000000FCFFFFFFFEFFFFFF05000000010000000000000002000000FCFFFFFFFBFFFFFFFFFFFFFF01000000000000000600000000000000FDFFFFFF00000000FEFFFFFF01000000FFFFFFFF00000000020000000400000001000000010000000000000005000000FFFFFFFF0500000005000000FFFFFFFF00000000FDFFFFFF0200000001000000FFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0200000000000000FFFFFFFFFDFFFFFFFDFFFFFF0100000003000000FCFFFFFF000000000100000000000000FDFFFFFF01000000FDFFFFFF00000000000000000000000003000000FFFFFFFFFFFFFFFF01000000FBFFFFFF010000000300000001000000FCFFFFFF000000000000000001000000FFFFFFFF02000000050000000000000000000000FDFFFFFF0000000000000000050000000200000000000000FFFFFFFF0000000000000000FFFFFFFF07000000FCFFFFFF00000000FFFFFFFFFCFFFFFF0100000001000000FEFFFFFF02000000FFFFFFFF0A000000FFFFFFFFFFFFFFFF01000000FFFFFFFF00000000FFFFFFFFFEFFFFFF000000000500000004000000FEFFFFFF0200000002000000000000000000000000000000000000000000000004000000FEFFFFFF01000000FFFFFFFF02000000000000000000000000000000FEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFF00000000"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}