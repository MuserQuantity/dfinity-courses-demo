import { microblog2 } from "../../declarations/microblog2";

// 发布
async function post() {
  let post_button = document.getElementById("post_button");
  post_button.disabled = true;
  let textarea = document.getElementById("message");
  let text = textarea.value;
  await microblog2.post(text);
  post_button.disabled = false;
}
var post_num = 0;
// 读取自己发布的
async function load_post() {
  let posts_section = document.getElementById("posts");
  let posts = await microblog2.posts(Date.parse(new Date())-3600*24*5);
  if (post_num == posts.length) return;
  posts_section.replaceChildren([]);
  post_num = posts.length;
  for (var i = 0; i < posts.length; i++) {
    let post = document.createElement("p");
    let author = "(未设名字)";
    if(posts[i].author!=""){
      author=posts[i].author;
    }
    post.innerText = i+1+". "+ author +':"'+ posts[i].text+'" on '+ bigint2timestr(posts[i].postTime);
    posts_section.appendChild(post);
  }
}
function bigint2timestr( timestamp ){
  let thousand = 1000n
  const t = timestamp/thousand;
  const d = new Date(Number(t));
  let date = d.toDateString();
  return date;
}

// 关注某id
// 读取所有关注的ids
async function load_follows(){
  let following_section = document.getElementById("following_section");
  let following = await microblog2.follows();
  following_section.replaceChildren([]);
  let following_num = following.length;
  for (var i = 0; i < following_num; i++) {
    let f = document.createElement("button");
    f.innerText = following[i];
    f.onclick=await load_following_posts(following[i]);
    following_section.appendChild(f);
  }
}

async function load_following_posts(id){
  console.log(id);
  let following_posts = document.getElementById("following_posts");
  let posts = await microblog2.following_posts(id,Date.parse(new Date())-3600*24*5);
  following_posts.replaceChildren([]);
  let following_posts_num = posts.length;
  for (var i = 0; i < following_posts_num; i++) {
    let post = document.createElement("p");
    let author = "(未设名字)";
    if(posts[i].author!=""){
      author=posts[i].author;
    }
    post.innerText = i+1+". "+ author +':"'+ posts[i].text+'" on '+ bigint2timestr(posts[i].postTime);
    following_posts.appendChild(post);
  }
}

async function load_timeline(){
  let timeline = document.getElementById("timeline");
  let posts = await microblog2.timeline(Date.parse(new Date())-3600*24*5);
  timeline.replaceChildren([]);
  let timeline_num = posts.length;
  for (var i = 0; i < timeline_num; i++) {
    let post = document.createElement("p");
    let author = "(未设名字)";
    if(posts[i].author!=""){
      author=posts[i].author;
    }
    post.innerText = i+1+". "+ author +':"'+ posts[i].text+'" on '+ bigint2timestr(posts[i].postTime);
    timeline.appendChild(post);
  }
}

// 初始化
function load() {
  var post_button = document.getElementById("post_button");
  post_button.onclick=post;
  load_post();
  load_follows();
  load_timeline();
}

window.onload = load