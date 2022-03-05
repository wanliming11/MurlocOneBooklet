//
// Created by Murloc Wan on 2022/3/5.
// 这是算法思考的一个子项：
// 如何处理切分思维和边界思维的一种思考

import Foundation

// MARK: 素材来自于：
// 1. https://wanliming.notion.site/6-Z-61680d0cd8f04680aa8f0b3a064346c2
// 思考点：在一个矩阵中规律的遍历应该如何切分的思考。
// 2. https://wanliming.notion.site/1800-29d23dde836448a886d18ed9395a3eea
// 思考点：梯度上升，然后下降，如何处理边界问题，相当于右边界和下降可以聚合成一个条件。

struct MMOAlgoBoundaryAndSlice {

    static func thinking() {
        MMOAlgoBoundaryAndSlice.LCode6SliceThinking()
        MMOAlgoBoundaryAndSlice.LCode1800BoundaryThinking()
    }

    /// 思考点1的代码
    static func LCode6SliceThinking() {
        // 因为顺序都是先向下遍历，再走对角线遍历，除去对角线两边，对角线走的个数是 rows - 2
        // 重复的内容是向下遍历，对角线遍历
        let cols = 0, rows = 0
        var col = 0, index = 0
        let characters: [Character] = Array("hello")
        var space = Array(repeating: Array(repeating: Character(" "), count: cols), count: rows)
        while col < cols, index < characters.count {
            // 向下
            for i in 0 ..< rows where index < characters.count {
                space[i][index] = characters[index]
                index += 1
            }

            // 对角线
            col += 1
            var midRow = rows - 2
            while midRow > 0, index < characters.count {
                space[midRow][col] = characters[index]
                midRow -= 1
                col += 1
                index += 1
            }
        }
    }

    /// 思考点2的代码
    static func LCode1800BoundaryThinking() {
        /// 因为递增然后下降  与 递增然后到边界 要做相同的处理： 算成同一端递增的内容
        /// 所以可以处理成同一个场景
        let nums: [Int] = [10,20,30,5,10,50]
        var right = 0
        while right < nums.count {
            if (right + 1 < nums.count && nums[right] >= nums[right + 1]) || right + 1 < nums.count {
                // 计算一整段的逻辑
                right += 1
            }
            else {
                right += 1
            }
        }
    }
}




