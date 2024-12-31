import SwiftUI

struct FindPattern: View {
    // 用來顯示搜尋結果的文字
    @State private var resultText: String = "尚未開始搜尋" // 初始結果文字
    
    // 建立 LPS 陣列的函式（用於 KMP 演算法加速搜尋）
    func createLPSArray(pattern: String) -> [Int] {
        // 將模式字串轉換成陣列，方便逐字處理
        let patternArray = Array(pattern)
        // 初始化 LPS 陣列，預設值為 0
        var lps = Array(repeating: 0, count: patternArray.count)
        var prev = 0 // 儲存當前最長的前綴長度
        var i = 1 // 從第二個字元開始計算

        // 計算每個位置的 LPS 值
        while i < patternArray.count {
            if patternArray[i] == patternArray[prev] {
                // 如果字元匹配，LPS 值為前綴長度加 1
                lps[i] = prev + 1
                i += 1
                prev += 1
            } else if prev == 0 {
                // 如果沒有匹配且前綴長度為 0，LPS 值為 0
                lps[i] = 0
                i += 1
            } else {
                // 如果沒有匹配但前綴長度不為 0，回退到上一個 LPS 值
                prev = lps[prev - 1]
            }
        }

        return lps // 返回完整的 LPS 陣列
    }

    // 使用 KMP 演算法進行字串搜尋
    func findPattern(_ str: String, _ pattern: String) -> Int {
        // 將主字串和模式字串轉換成陣列
        let textArray = Array(str)
        let patternArray = Array(pattern)
        // 取得模式字串的 LPS 陣列
        let lps = createLPSArray(pattern: pattern)

        var i = 0 // 主字串的索引
        var j = 0 // 模式字串的索引

        // 開始進行字串匹配
        while i < textArray.count {
            if textArray[i] == patternArray[j] {
                // 如果字元匹配，繼續檢查下一個字元
                i += 1
                j += 1
            } else {
                if j == 0 {
                    // 如果模式字串的索引已經回到起點，移動主字串索引
                    i += 1
                } else {
                    // 否則根據 LPS 陣列更新模式字串的索引
                    j = lps[j - 1]
                }
            }

            // 如果模式字串完全匹配，返回起始索引
            if j == patternArray.count {
                return i - patternArray.count
            }
        }

        return -1 // 如果沒有匹配，返回 -1
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 標題文字
            Text("字串搜尋工具")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // 提示用戶按下按鈕
            Text("按下按鈕開始搜尋特定模式字串")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // 搜尋按鈕
            Button("開始搜尋") {
                // 測試用的主字串和模式字串
                let text = "ABCDABCDABCDE"
                let pattern = "CDE"
                
                // 執行搜尋
                let result = findPattern(text, pattern)
                // 更新結果文字
                resultText = result == -1
                    ? "搜尋失敗：模式字串未找到"
                    : "搜尋成功：模式字串位於索引 \(result)"
            }
            .padding()
            .background(Color.blue) // 按鈕背景顏色
            .foregroundColor(.white) // 按鈕文字顏色
            .cornerRadius(10) // 按鈕圓角設計
            
            // 顯示搜尋結果
            Text(resultText)
                .font(.body)
                .foregroundColor(.primary)
                .padding()
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    FindPattern()
}
