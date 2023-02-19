# 424. Longest Repeating Character Replacement

Prompt: You are given a string s and an integer k. You can choose any character of the string and change it to any other uppercase English character. 
You can perform this operation at most k times.
Return the length of the longest substring containing the same letter you can get after performing the above operations.


Answer:
```
class Solution:
    def characterReplacement(self, s: str, k: int) -> int:
        """
        Sliding Window
        'ABCDEF'
         ^
          ^
        count_hash = { 'A': 1, 'B': 1 } <-- next iteration moves up the Window
        if count_max_frequent_char - len_of_window > k:
            count_hash[char_i] -= 1
            i += 1 <-- move the window up
        longest_repeating_substr = max(longest_repeating_substr, j - i)
        """

        char_freq_hash = {}
        i, j = 0, 0
        longest_repeating_substr = 0
        max_freq_char = 0
        for char in s:
            if char in char_freq_hash:
                char_freq_hash[char] += 1
            else:
                char_freq_hash[char] = 1
            
            max_freq_char = max(max_freq_char, char_freq_hash[char])
            current_substr_len = (j - i) + 1
            if current_substr_len - max_freq_char > k:
                char_freq_hash[s[i]] -= 1
                i += 1
            longest_repeating_substr = max(longest_repeating_substr, (j - i) + 1)
            j += 1
        return longest_repeating_substr
```

* This is a sliding window problem
* Have a hash that counts the frequency of every character in the window
* If the most frequent character - length of the current string is greater than k than we need to move the window up
* Pop the trailing character out of the window and keep track of the longest substring

