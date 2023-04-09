# 424. Longest Repeating Character Replacement

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



# 33. Search in Rotated Sorted Array

```
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        """Augmented binary search, 
        if the left is sorted and contains the range of our number call binary
        search
        else shift to other half

        if the right is sorted and container the range of our number call binary 
        search
        else shift this binary search to the other half
        """
        l = 0
        r = len(nums) - 1

        while l <= r:
            mid = (l + r) // 2
            if nums[mid] == target:
                return mid
            
            # check if right is sorted and target is in range
            if nums[l] <= nums[mid]:
                if nums[l] <= target <= nums[mid]:
                    return self._binary_search(nums, l, r, target)
                # else its in the right hand side
                else:
                    l = mid + 1

            # check if right is sorted and target is in range
            if nums[mid] <= nums[r]:
                if nums[mid] <= target <= nums[r]:
                    return self._binary_search(nums, l, r, target)
                # else its in the left hand side
                else:
                    r = mid - 1
        return -1

    def _binary_search(self, arr, l, r, t) -> int:
        """Simple binary search algorithm"""
        while l <= r:
            mid = (l + r) // 2
            if arr[mid] == t:
                return mid
            
            if arr[mid] > t:
                r = mid - 1
            else:
                l = mid + 1

        return -1 
```

* This is a binary search approach where I am constantly changing the window and attempting to find the
appropriate place to begin binary search
* In algoexpert and other solutions the use of this `binary_search` helper method is excluded but, 
if focusing on solving the problem from "is the array sorted and is my target present" I felt it 
makes more sense.
* TLDR; One side is sorted and the other is not, check the sorted side to see if my target is in the range
if it is not then it must be in the other half, essentially "recursively" run this same algorithm but
now on the unsorted side. Split this unsorted side in half, out of the two sides, which one is sorted?
Begin the same logic over and over.


# 153. Find Minimum in Sorted Array

```
class Solution:
    def findMin(self, nums: List[int]) -> int:
        """
        Augmented binary search, looking for the begining of
        the sorted array

        [4,5,6,7,0,1,2]
               ^
        
        """

        l = 0
        r = len(nums) - 1
        min_num_found = 2 ** 32 

        while l <= r:
            mid = (l + r) // 2
            # check if right is sorted and target is in range
            if nums[l] <= nums[mid]:
                min_num_found = min(nums[l], min_num_found)
                l = mid + 1
            # check if right is sorted and target is in range
            if nums[mid] <= nums[r]:
                min_num_found = min(nums[mid], min_num_found)
                r = mid - 1
                

        return min_num_found
```

* Same idea as above but a bit more elegant, and only checking the beginning
of every sorted half


# 21. Merge Two Sorted Lists

```
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def mergeTwoLists(self, list1: Optional[ListNode], list2: Optional[ListNode]) -> Optional[ListNode]:
        """ 
        1 > 2 > 4
        1 > 3 > 4

        1 > 1 > 2 > 3 > 4 > 4

        picking the first list

        # merge
        while l1:
            if l1.val >= l2.val and l1.next != None and l2.val <= l1.next.val:
                1 > 1 > 2 > 4
                3 > 4


        # append remaining and return
        while l2:
            # append l2 to l1
        
        return l1_head

        """
        if not list1:
            return list2
        if not list2:
            return list1

        l1_tail = list1
        while l1_tail.next:
            l1_tail = l1_tail.next

        l1_head = list1

        prev_list1 = None
        while list1:
            while (list1 != None and list2 != None) and list1.val > list2.val: 
                if not prev_list1:
                    l1_head = list2
                    temp_list2 = list2.next
                    list2.next = list1
                    prev_list1 = list2
                    list2 = temp_list2
                    continue

                temp_list2 = list2.next
                prev_list1.next = list2
                list2.next = list1

                prev_list1 = list2
                list2 = temp_list2

            # iterate
            prev_list1 = list1
            list1 = list1.next
        
        
        l1_tail.next = list2

        return l1_head

    def _print_list(self, l):
        curr = l
        rep = ''
        while curr:
            rep += str(curr.val) + ' > '
            curr = curr.next
        print(rep)
            
```

* Pick one list to merge into
* Draw out picture
* Edge case where we need to set a new head of the list

# 143. Reorder List

```
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def reorderList(self, head: ListNode) -> None:
        """
        Do not return anything, modify head in-place instead.
        """

        in_order_first_half, reversed_second_half = self._split_in_half(head)

        curr_node_n = reversed_second_half
        curr_node_i = in_order_first_half
        while curr_node_i:
            if not curr_node_i.next:
                curr_node_i.next = curr_node_n
                return head

            temp_i = curr_node_i.next
            temp_n = curr_node_n.next

            curr_node_i.next = curr_node_n
            curr_node_n.next = temp_i

            curr_node_i = temp_i
            curr_node_n = temp_n
        return head

    def _split_in_half(self, head):
        list_len = self._size_of_list(head)
        mid = list_len // 2
        in_order_first_half = head
        for _ in range(1, mid):
            head = head.next

        temp = head.next
        head.next = None
        head = temp

        # Reverse last half
        prev = None
        while head:
            temp = head.next
            head.next = prev
            prev = head
            head = temp
        reversed_second_half = prev
        return in_order_first_half, reversed_second_half
        
    def _size_of_list(self, head):
        size_of_list = 0
        while head:
            size_of_list += 1
            head = head.next
        return size_of_list
    
    def _print_list(self, head):
        rep = ''
        while head:
            rep += str(head.val) + ' > '
            head = head.next
        print(rep)
```

* The trick here is to create two lists
* The first half in order and the second half reversed
* This will be O(n) time (1) mem
