import Foundation

func solution(value1: Int, weight1: Int, value2: Int, weight2: Int, maxW: Int) -> Int {
    // Check if both items can be carried
    if weight1 + weight2 <= maxW {
        return value1 + value2
    }
    
    // Check if only one of the items can be carried
    if weight1 <= maxW && weight2 <= maxW {
        return max(value1, value2)
    }
    
    // If only the first item can be carried
    if weight1 <= maxW {
        return value1
    }
    
    // If only the second item can be carried
    if weight2 <= maxW {
        return value2
    }
    
    // If neither item can be carried
    return 0
}

solution(value1: 10, weight1: 5, value2: 6, weight2: 4, maxW: 8)
solution(value1: 10, weight1: 5, value2: 6, weight2: 4, maxW: 9)
solution(value1: 5, weight1: 3, value2: 7, weight2: 4, maxW: 6)
