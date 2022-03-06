import Text "mo:base/Text";
actor Counter {

  stable var currentValue : Nat = 0;
  
  public func increment() : async () {
    currentValue += 1;
  };

  public query func get() : async Nat {
    currentValue;
  };

  public func set(n: Nat) : async () {
    currentValue := n;
  };

}