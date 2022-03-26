import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
actor {
    public type Message = {
        author : Text;
        text : Text;
        postTime : Time.Time;
    };

    public type Microblog = actor{
        flollow: shared(Principal) -> async();
        flollows: shared query () -> async [Principal];
        post: shared (Text) -> async ();
        posts: shared query (since: Time.Time) -> async [Message];
        set_name: shared (name : Text) -> async ();
        get_name: shared query () -> async ?Text;
        timeline : shared (since: Time.Time) -> async [Message];
    };

    stable var followed : List.List<Principal> = List.nil();

    public shared func follow(id: Principal) : async (){
        followed := List.push(id, followed);
    };

    public shared query func follows(): async [Principal]{
        List.toArray(followed)
    };
    var name =  "";
    public shared func set_name(text : Text) : async (){
        name := text;
    };

    public shared query func get_name() : async ?Text {
        return ?name;
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
        // assert(Principal.toText(msg.caller) == "5my5l-2spbm-3mfcw-6m4bh-wgizf-gocfb-6vir3-6hc6n-lq2jq-2dznv-sae");
        let message = {
            author = name;
            text = text;
            postTime = Time.now();
        };
        messages := List.push(message, messages);
    };

    public shared query func posts(since: Time.Time) : async [Message] {
        let results = filter(since);
        return results;
    };

    public shared func following_posts(id:Principal,since:Time.Time): async [Message]{
        let canister: Microblog = actor(Principal.toText(id));
        let msgs = await canister.posts(since);
        return msgs;
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
