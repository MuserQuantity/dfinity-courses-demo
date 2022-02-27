// actor {
//     public func greet(name : Text) : async Text {
//         return "Hello, " # name # "!";
//     };
// };
import Debug "mo:base/Debug";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";

actor{
    func division(number:[var Int],first:Int,last:Int):Int{
        // 以最左边的数为基准
        var base:Int = number[Int.abs(first)];
        var l = first;
        var r = last;
        while ( l < r ) {
            // 从右边开始向左遍历，直到找到小于base的数
            while (l < r and number[Int.abs(r)] >= base) {
                r -= 1;
            };
            // 找到该数后，放到最左边
            number[Int.abs(l)]:=number[Int.abs(r)];
            // 从左边开始向右遍历，直到找到大于base的数
            while ( l < r and number[Int.abs(l)] <= base) {
                l += 1;
            };
            // 找到该数后，放到最右边
            number[Int.abs(r)]:=number[Int.abs(l)];
        };
        // 将base放置left位置，此时所有左侧都比left小，右侧都比left大，返回
        number[Int.abs(l)]:=base;
        return l;
    };
    func quick_sort(number:[var Int],l:Int,r:Int){
        if ( l < r ) {
            var base:Int=division(number,l,r);
            quick_sort(number,l,base-1);
            quick_sort(number,base+1,r);
        };
    };
    public func qsort(arr: [Int]): async [Int]{
        let l:Int = 0;
        let r:Int = arr.size()-1;
        var number = Array.thaw<Int>(arr);
        quick_sort(number,l,r);
        return Array.freeze<Int>(number);
    };
}