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


# 76. Minimum Window Substring

Prompt: Given two strings s and t of lengths m and n respectively, return the minimum window 
substring of s such that every character in t (including duplicates) is included in the window. If there is no such substring, return the empty string "".

Answer:
```
class Solution:
    def minWindow(self, s: str, t: str) -> str:
        """
        s = "ADOBECODEBANC", t = "ABC"
             ^
                       ^
        return "BANC" <-- as this is the smallest substr possible with t's chars
        char_count = {}
        O(26) * O(N)
        while every char count == 1 
            i -= 1
        if any char count == 0 
            j += 1
        """

        char_count = {}
        required_char_count = {}
        for char in t:
            char_count[char] = 0
            if char in required_char_count:
                required_char_count[char] += 1
            else:
                required_char_count[char] = 1

        
        i = 0
        j = 0
        min_substring = ""
        while self._is_correct_substring(char_count, required_char_count) == False and j < len(s):
            char_j = s[j]
            if char_j in char_count:
                char_count[char_j] += 1

            while self._is_correct_substring(char_count, required_char_count):
                char_i = s[i]
                if not min_substring or len(min_substring) > (j - i):
                    min_substring = s[i:j+1]

                if char_i in char_count:
                    char_count[char_i] -= 1
                i += 1
            j += 1

        return min_substring

    def _is_correct_substring(self, char_count, required_char_count):
        for k, v in char_count.items():
            if v < required_char_count[k]:
                return False
        return True
```

* Use a sliding window and while we have the correct substring make the window smaller, if not continue adding to it
* This uses a fun O(26) implemention, essentially the for loops don't add any time complexity due to alpha


# 20. Valid Parentheses

Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.
An input string is valid if:
Open brackets must be closed by the same type of brackets.
Open brackets must be closed in the correct order.
Every close bracket has a corresponding open bracket of the same type.

```
class Solution:
    def isValid(self, s: str) -> bool:
        """
        paren_stack = []
        [] <-- if opening parem add to stack
        [] <-- if matching closing parem pop open from stack
        closing_brackets = { ')' : '(', '}' : '{', ']':'[' }
        return len(paren_stack) == 0

        s = "({[}])"
        [ ({ ] <-- returns false

        """

        paren_stack = []
        closing_brackets = { ')' : '(', '}' : '{', ']':'[' }

        for bracket in s:
            if bracket not in closing_brackets:
                paren_stack.append(bracket)
            elif paren_stack and paren_stack[-1] == closing_brackets[bracket]:
                paren_stack.pop()
            else:
                return False
        
        return len(paren_stack) == 0
```

* Simple stack, when the top of the stack does not have the opening bracket return false
* Else check to see whether the stack is empty (this would mean all matches have been found)
* I messed up on the immediate returning false bit, this is important as once there is no match
the solution can never be true ie [']]]]]]'] is False