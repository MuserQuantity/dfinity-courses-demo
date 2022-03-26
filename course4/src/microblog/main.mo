import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
actor {
    public type Message = {
        text : Text;
        postTime : Time.Time;
    };

    public type Microblog = actor{
        flollow: shared(Principal) -> async();
        flollows: shared query () -> async [Principal];
        post: shared (Text) -> async ();
        posts: shared query (since: Time.Time) -> async [Message];
        timeline : shared (since: Time.Time) -> async [Message];
    };

    stable var followed : List.List<Principal> = List.nil();

    public shared func follow(id: Principal) : async (){
        followed := List.push(id, followed);
    };

    public shared query func follows(): async [Principal]{
        List.toArray(followed)
    };

    stable var messages : List.List<Message> = List.nil();

    func filter(since: Time.Time):[Message]{
        var results : List.List<Message> = List.nil();
        for (message in Iter.fromList(messages)){
            if(message.postTime > since){
                results := List.push(message,results)
            }
        };
        List.toArray(results)
    };

    public shared (msg) func post(text : Text) : async (){
        assert(Principal.toText(msg.caller) == "5my5l-2spbm-3mfcw-6m4bh-wgizf-gocfb-6vir3-6hc6n-lq2jq-2dznv-sae");
        let message = {
            text = text;
            postTime = Time.now();
        };
        messages := List.push(message, messages);
    };

    public shared query func posts(since: Time.Time) : async [Message] {
        let results = filter(since);
        return results;
    };

    public shared func timeline(since: Time.Time) : async [Message] {
        var all : List.List<Message> = List.nil();

        for (id in Iter.fromList(followed)){
            let canister: Microblog =actor(Principal.toText(id));
            let msgs = await canister.posts(since);
            for (msg in Iter.fromArray(msgs)){
                all := List.push(msg,all)
            }
        };
        List.toArray(all)
    };
};
