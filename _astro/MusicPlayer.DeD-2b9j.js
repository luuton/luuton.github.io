import{o as Sa,a as Pa,i as za,s as N,b as it,e as Me}from"./lifecycle.BEG9Hqc7.js";import{a3 as Ia,aa as $a,aH as Ra,aI as Wa,o as Na,u as Ya,aJ as qa,aK as ze,aL as Ka,v as Oa,aM as ht,c as st,f as tt,a as Y,p as Ha,b as Ua,h as o,m as F,aF as O,g as t,d as vt,s as v,e as i,r,n as Va,t as Pt,k as h}from"./utils.BRGgQGxY.js";import{a as Xa,s as G}from"./render.BvoO-zwv.js";import{i as z}from"./if.DArQ9Kbp.js";import{e as Ga,i as Ja}from"./each.BJig15T2.js";import{b as Te}from"./this.C5OF1Wpg.js";import{I as f}from"./Icon.BAZp79VP.js";import{m as xt}from"./config.BCAPSS0j.js";import{I as Qa}from"./zh_TW.D-i86LJH.js";import{i as Za}from"./translation.OUt3XocX.js";import"./props.CFgvYuj9.js";const tr=()=>performance.now(),J={tick:c=>requestAnimationFrame(c),now:()=>tr(),tasks:new Set};function Ie(){const c=J.now();J.tasks.forEach(s=>{s.c(c)||(J.tasks.delete(s),s.f())}),J.tasks.size!==0&&J.tick(Ie)}function er(c){let s;return J.tasks.size===0&&J.tick(Ie),{promise:new Promise(w=>{J.tasks.add(s={c,f:w})}),abort(){J.tasks.delete(s)}}}function zt(c,s){ze(()=>{c.dispatchEvent(new CustomEvent(s))})}function ar(c){if(c==="float")return"cssFloat";if(c==="offset")return"cssOffset";if(c.startsWith("--"))return c;const s=c.split("-");return s.length===1?s[0]:s[0]+s.slice(1).map(w=>w[0].toUpperCase()+w.slice(1)).join("")}function Se(c){const s={},w=c.split(";");for(const E of w){const[L,C]=E.split(":");if(!L||C===void 0)break;const I=ar(L.trim());s[I]=C.trim()}return s}const rr=c=>c;function ir(c,s,w,E){var L=(c&qa)!==0,C="both",I,x=s.inert,A=s.style.overflow,d,b;function P(){return ze(()=>I??=w()(s,E?.()??{},{direction:C}))}var k={is_global:L,in(){s.inert=x,zt(s,"introstart"),d=ae(s,P(),b,1,()=>{zt(s,"introend"),d?.abort(),d=I=void 0,s.style.overflow=A})},out(T){s.inert=!0,zt(s,"outrostart"),b=ae(s,P(),d,0,()=>{zt(s,"outroend"),T?.()})},stop:()=>{d?.abort(),b?.abort()}},j=Ia;if((j.transitions??=[]).push(k),Xa){var M=L;if(!M){for(var u=j.parent;u&&(u.f&$a)!==0;)for(;(u=u.parent)&&(u.f&Ra)===0;);M=!u||(u.f&Wa)!==0}M&&Na(()=>{Ya(()=>k.in())})}}function ae(c,s,w,E,L){var C=E===1;if(Ka(s)){var I,x=!1;return Oa(()=>{if(!x){var T=s({direction:C?"in":"out"});I=ae(c,T,w,E,L)}}),{abort:()=>{x=!0,I?.abort()},deactivate:()=>I.deactivate(),reset:()=>I.reset(),t:()=>I.t()}}if(w?.deactivate(),!s?.duration)return L(),{abort:ht,deactivate:ht,reset:ht,t:()=>E};const{delay:A=0,css:d,tick:b,easing:P=rr}=s;var k=[];if(C&&w===void 0&&(b&&b(0,1),d)){var j=Se(d(0,1));k.push(j,j)}var M=()=>1-E,u=c.animate(k,{duration:A,fill:"forwards"});return u.onfinish=()=>{u.cancel();var T=w?.t()??1-E;w?.abort();var g=E-T,et=s.duration*Math.abs(g),at=[];if(et>0){var $=!1;if(d)for(var p=Math.ceil(et/16.666666666666668),y=0;y<=p;y+=1){var a=T+g*P(y/p),Q=Se(d(a,1-a));at.push(Q),$||=Q.overflow==="hidden"}$&&(c.style.overflow="hidden"),M=()=>{var H=u.currentTime;return T+g*P(H/et)},b&&er(()=>{if(u.playState!=="running")return!1;var H=M();return b(H,1-H),!0})}u=c.animate(at,{duration:et,fill:"forwards"}),u.onfinish=()=>{M=()=>E,b?.(E,1-E),L()}},{abort:()=>{u&&(u.cancel(),u.effect=null,u.onfinish=ht)},deactivate:()=>{L=ht},reset:()=>{E===0&&b?.(1,0)},t:()=>M()}}function Pe(c){return function(...s){var w=s[0];return w.stopPropagation(),c?.apply(this,s)}}function sr(c){const s=c-1;return s*s*s+1}function nr(c,{delay:s=0,duration:w=400,easing:E=sr,axis:L="y"}={}){const C=getComputedStyle(c),I=+C.opacity,x=L==="y"?"height":"width",A=parseFloat(C[x]),d=L==="y"?["top","bottom"]:["left","right"],b=d.map(g=>`${g[0].toUpperCase()}${g.slice(1)}`),P=parseFloat(C[`padding${b[0]}`]),k=parseFloat(C[`padding${b[1]}`]),j=parseFloat(C[`margin${b[0]}`]),M=parseFloat(C[`margin${b[1]}`]),u=parseFloat(C[`border${b[0]}Width`]),T=parseFloat(C[`border${b[1]}Width`]);return{delay:s,duration:w,easing:E,css:g=>`overflow: hidden;opacity: ${Math.min(g*20,1)*I};${x}: ${g*A}px;padding-${d[0]}: ${g*P}px;padding-${d[1]}: ${g*k}px;margin-${d[0]}: ${g*j}px;margin-${d[1]}: ${g*M}px;border-${d[0]}-width: ${g*u}px;border-${d[1]}-width: ${g*T}px;min-${x}: 0`}}var lr=vt('<div class="fixed bottom-20 right-4 z-[60] max-w-sm"><div class="bg-red-500 text-white px-4 py-3 rounded-lg shadow-lg flex items-center gap-3 animate-slide-up"><!> <span class="text-sm flex-1"> </span> <button class="text-white/80 hover:text-white transition-colors"><!></button></div></div>'),or=vt('<div class="flex space-x-0.5"><div class="w-0.5 h-3 bg-white rounded-full animate-pulse"></div> <div class="w-0.5 h-4 bg-white rounded-full animate-pulse" style="animation-delay: 150ms;"></div> <div class="w-0.5 h-2 bg-white rounded-full animate-pulse" style="animation-delay: 300ms;"></div></div>'),ur=vt('<span class="text-sm text-[var(--content-meta)]"></span>'),cr=vt('<div role="button" tabindex="0"><div class="w-6 h-6 flex items-center justify-center"><!></div> <div class="w-10 h-10 rounded-lg overflow-hidden bg-[var(--btn-regular-bg)] flex-shrink-0"><img class="w-full h-full object-cover"/></div> <div class="flex-1 min-w-0"><div> </div> <div> </div></div></div>'),dr=vt('<div class="playlist-panel float-panel fixed bottom-20 right-4 w-80 max-h-96 overflow-hidden z-50"><div class="playlist-header flex items-center justify-between p-4 border-b border-[var(--line-divider)]"><h3 class="text-lg font-semibold text-90"> </h3> <button class="btn-plain w-8 h-8 rounded-lg"><!></button></div> <div class="playlist-content overflow-y-auto max-h-80"></div></div>'),vr=vt(`<!> <div><div role="button" tabindex="0" aria-label="显示音乐播放器"><!></div> <div role="button" tabindex="0" aria-label="展开音乐播放器"><div class="flex items-center gap-3 cursor-pointer"><div class="cover-container relative w-12 h-12 rounded-full overflow-hidden"><img alt="封面"/> <div class="absolute inset-0 bg-black/20 flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity"><!></div></div> <div class="flex-1 min-w-0"><div class="text-sm font-medium text-90 truncate"> </div> <div class="text-xs text-50 truncate"> </div></div> <div class="flex items-center gap-1"><button class="btn-plain w-8 h-8 rounded-lg flex items-center justify-center" title="隐藏播放器"><!></button> <button class="btn-plain w-8 h-8 rounded-lg flex items-center justify-center"><!></button></div></div></div> <div><div class="flex items-center gap-4 mb-4"><div class="cover-container relative w-16 h-16 rounded-full overflow-hidden flex-shrink-0"><img alt="封面"/></div> <div class="flex-1 min-w-0"><div class="song-title text-lg font-bold text-90 truncate mb-1"> </div> <div class="song-artist text-sm text-50 truncate"> </div> <div class="text-xs text-30 mt-1"> </div></div> <div class="flex items-center gap-1"><button class="btn-plain w-8 h-8 rounded-lg flex items-center justify-center" title="隐藏播放器"><!></button> <button class="btn-plain w-8 h-8 rounded-lg flex items-center justify-center"><!></button></div></div> <div class="progress-section mb-4"><div class="progress-bar flex-1 h-2 bg-[var(--btn-regular-bg)] rounded-full cursor-pointer" role="slider" tabindex="0" aria-label="播放进度" aria-valuemin="0" aria-valuemax="100"><div class="h-full bg-[var(--primary)] rounded-full transition-all duration-100"></div></div></div> <div class="controls flex items-center justify-center gap-2 mb-4"><button><!></button> <button class="btn-plain w-10 h-10 rounded-lg"><!></button> <button><!></button> <button class="btn-plain w-10 h-10 rounded-lg"><!></button> <button><!></button></div> <div class="bottom-controls flex items-center gap-2"><button class="btn-plain w-8 h-8 rounded-lg"><!></button> <div class="flex-1 h-2 bg-[var(--btn-regular-bg)] rounded-full cursor-pointer" role="slider" tabindex="0" aria-label="音量控制" aria-valuemin="0" aria-valuemax="100"><div class="h-full bg-[var(--primary)] rounded-full transition-all duration-100"></div></div> <button><!></button></div></div> <!></div> <style>.orb-player {
	position: relative;
	backdrop-filter: blur(10px);
	-webkit-backdrop-filter: blur(10px);
}
.orb-player::before {
	content: '';
	position: absolute;
	inset: -2px;
	background: linear-gradient(45deg, var(--primary), transparent, var(--primary));
	border-radius: 50%;
	z-index: -1;
	opacity: 0;
	transition: opacity 0.3s ease;
}
.orb-player:hover::before {
	opacity: 0.3;
	animation: rotate 2s linear infinite;
}
.orb-player .animate-pulse {
	animation: musicWave 1.5s ease-in-out infinite;
}
@keyframes rotate {
	from { transform: rotate(0deg); }
	to { transform: rotate(360deg); }
}
@keyframes musicWave {
	0%, 100% { transform: scaleY(0.5); }
	50% { transform: scaleY(1); }
}
.music-player.hidden-mode {
	width: 48px;
	height: 48px;
}
.music-player {
    max-width: 320px;
    -webkit-user-select: none;
       -moz-user-select: none;
            user-select: none;
}
.mini-player {
    width: 280px;
    position: absolute;
    bottom: 0;
    right: 0;
    /*left: 0;*/
}
.expanded-player {
    width: 320px;
    position: absolute;
    bottom: 0;
    right: 0;
}
.animate-pulse {
    animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
@keyframes pulse {
    0%, 100% {
        opacity: 1;
    }
    50% {
        opacity: 0.5;
    }
}
.progress-section div:hover,
.bottom-controls > div:hover {
    transform: scaleY(1.2);
    transition: transform 0.2s ease;
}
@media (max-width: 768px) {
    .music-player {
        max-width: 280px;
        /*left: 8px !important;*/
        bottom: 8px !important;
        right: 8px !important;
    }
    .music-player.expanded {
        width: calc(100vw - 16px);
        max-width: none;
        /*left: 8px !important;*/
        right: 8px !important;
    }
    .playlist-panel {
        width: calc(100vw - 16px) !important;
        /*left: 8px !important;*/
        right: 8px !important;
        max-width: none;
    }
    .controls {
        gap: 8px;
    }
    .controls button {
        width: 36px;
        height: 36px;
    }
    .controls button:nth-child(3) {
        width: 44px;
        height: 44px;
    }
}
@media (max-width: 480px) {
    .music-player {
        max-width: 260px;
    }
    .song-title {
        font-size: 14px;
    }
    .song-artist {
        font-size: 12px;
    }
    .controls {
        gap: 6px;
        margin-bottom: 12px;
    }
    .controls button {
        width: 32px;
        height: 32px;
    }
    .controls button:nth-child(3) {
        width: 40px;
        height: 40px;
    }
    .playlist-item {
        padding: 8px 12px;
    }
    .playlist-item .w-10 {
        width: 32px;
        height: 32px;
    }
}
@keyframes slide-up {
    from {
        transform: translateY(100%);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
    }
}
.animate-slide-up {
    animation: slide-up 0.3s ease-out;
}
@media (hover: none) and (pointer: coarse) {
    .music-player button,
    .playlist-item {
        min-height: 44px;
    }
    .progress-section > div,
    .bottom-controls > div:nth-child(2) {
        height: 12px;
    }
}
/* 自定义旋转动画，停止时保持当前位置 */
@keyframes spin-continuous {
    from {
        transform: rotate(0deg);
    }
    to {
        transform: rotate(360deg);
    }
}
.cover-container img {
    animation: spin-continuous 3s linear infinite;
    animation-play-state: paused;
}
.cover-container img.spinning {
    animation-play-state: running;
}
/* 让主题色按钮更有视觉反馈 */
button.bg-\\[var\\(--primary\\)\\] {
    box-shadow: 0 0 0 2px var(--primary);
    border: none;
}</style>`,1);function kr(c,s){Ua(s,!1);let w=xt.mode??"local",E=xt.meting_api??"https://www.bilibili.uno/api?server=:server&type=:type&id=:id&auth=:auth&r=:r",L=xt.id??"14164869977",C=xt.server??"netease",I=xt.type??"playlist",x=F(!1),A=F(!1),d=F(!1),b=F(!1),P=F(0),k=F(0),j=F(.3),M=F(!1),u=F(!1),T=F(!1),g=F(2),et=F("error"),at=F(!1),$=F({title:"示例歌曲",artist:"示例艺术家",cover:"/favicon/favicon-light-192.png",url:"",duration:0}),p=F([]),y=F(0),a=F(),Q=F(),H=F();const $e=[{id:1,title:"三日月の舞 (関西大会突破 Ver.）",artist:"北宇治高校吹奏楽部",cover:"assets/music/cover/sryzw.jpg",url:"assets/music/url/sryzw.mp3",duration:240},{id:2,title:"衡山路宛平路",artist:"ChiliChill",cover:"assets/music/cover/衡山路宛平路.jpg",url:"assets/music/url/衡山路宛平路.mp3",duration:240},{id:3,title:"コロニーの彼女（I_006A）",artist:"照井順政",cover:"assets/music/cover/コロニーの彼女（I_006A）.jpg",url:"assets/music/url/コロニーの彼女（I_006A）.mp3",duration:240},{id:4,title:"眩耀夜行",artist:"スリーズブーケ",cover:"assets/music/cover/xryx.jpg",url:"assets/music/url/xryx.mp3",duration:180},{id:5,title:"春雷の頃",artist:"22/7",cover:"assets/music/cover/cl.jpg",url:"assets/music/url/cl.mp3",duration:200},{id:6,title:"ひとり上手",artist:"Kaya",cover:"assets/music/cover/hitori.jpg",url:"assets/music/url/hitori.mp3",duration:240}];async function Re(){if(!E||!L)return;o(u,!0);const n=E.replace(":server",C).replace(":type",I).replace(":id",L).replace(":auth","").replace(":r",Date.now().toString());try{const S=await fetch(n);if(!S.ok)throw new Error("meting api error");const U=await S.json();o(p,U.map(W=>{let ft=W.name??W.title??"未知歌曲",Ft=W.artist??W.author??"未知艺术家",R=W.duration??0;return R>1e4&&(R=Math.floor(R/1e3)),(!Number.isFinite(R)||R<=0)&&(R=0),{id:W.id,title:ft,artist:Ft,cover:W.pic??"",url:W.url??"",duration:R}})),t(p).length>0&&$t(t(p)[0]),o(u,!1)}catch{kt("Meting 歌单获取失败"),o(u,!1)}}function We(){!t(a)||!t($).url||(t(x)?t(a).pause():t(a).play())}function yt(){o(A,!t(A)),t(A)&&(o(b,!1),o(d,!1))}function _t(){o(d,!t(d)),t(d)&&(o(A,!1),o(b,!1))}function re(){o(b,!t(b))}function Ne(){o(T,!t(T))}function Ye(){o(g,(t(g)+1)%3)}function qe(){if(t(p).length<=1)return;const n=t(y)>0?t(y)-1:t(p).length-1;wt(n)}function It(){if(t(p).length<=1)return;let n;if(t(T))do n=Math.floor(Math.random()*t(p).length);while(n===t(y)&&t(p).length>1);else n=t(y)<t(p).length-1?t(y)+1:0;wt(n)}function wt(n){if(n<0||n>=t(p).length)return;const S=t(x);o(y,n),t(a)&&t(a).pause(),$t(t(p)[t(y)]),(S||!t(x))&&setTimeout(()=>{t(a)&&(t(a).readyState>=2?t(a).play().catch(()=>{}):t(a).addEventListener("canplay",()=>{t(a).play().catch(()=>{})},{once:!0}))},100)}function Et(n){return n.startsWith("http://")||n.startsWith("https://")||n.startsWith("/")?n:`/${n}`}function $t(n){!n||!t(a)||(o($,{...n}),n.url?(o(u,!0),t(a).pause(),O(a,t(a).currentTime=0),o(P,0),o(k,n.duration??0),t(a).removeEventListener("loadeddata",ie),t(a).removeEventListener("error",se),t(a).removeEventListener("loadstart",ne),t(a).addEventListener("loadeddata",ie,{once:!0}),t(a).addEventListener("error",se,{once:!0}),t(a).addEventListener("loadstart",ne,{once:!0}),O(a,t(a).src=Et(n.url)),t(a).load()):o(u,!1))}function ie(){o(u,!1),t(a)?.duration&&t(a).duration>1&&(o(k,Math.floor(t(a).duration)),t(p)[t(y)]&&O(p,t(p)[t(y)].duration=t(k)),O($,t($).duration=t(k)))}function se(n){o(u,!1),kt(`无法播放 "${t($).title}"，正在尝试下一首...`),t(p).length>1?setTimeout(()=>It(),1e3):kt("播放列表中没有可用的歌曲")}function ne(){}function kt(n){o(et,n),o(at,!0),setTimeout(()=>{o(at,!1)},3e3)}function Ke(){o(at,!1)}function Oe(n){if(!t(a)||!t(Q))return;const S=t(Q).getBoundingClientRect(),W=(n.clientX-S.left)/S.width*t(k);O(a,t(a).currentTime=W),o(P,W)}function He(n){if(!t(a)||!t(H))return;const S=t(H).getBoundingClientRect(),U=Math.max(0,Math.min(1,(n.clientX-S.left)/S.width));o(j,U),O(a,t(a).volume=t(j)),o(M,t(j)===0)}function le(){t(a)&&(o(M,!t(M)),O(a,t(a).muted=t(M)))}function oe(n){if(!Number.isFinite(n)||n<0)return"0:00";const S=Math.floor(n/60),U=Math.floor(n%60);return`${S}:${U.toString().padStart(2,"0")}`}function Ue(){t(a)&&(t(a).addEventListener("play",()=>{o(x,!0)}),t(a).addEventListener("pause",()=>{o(x,!1)}),t(a).addEventListener("timeupdate",()=>{o(P,t(a).currentTime)}),t(a).addEventListener("ended",()=>{t(g)===1?(O(a,t(a).currentTime=0),t(a).play().catch(()=>{})):t(g)===2||t(y)<t(p).length-1||t(T)?It():o(x,!1)}),t(a).addEventListener("error",n=>{o(u,!1)}),t(a).addEventListener("stalled",()=>{}),t(a).addEventListener("waiting",()=>{}))}Sa(()=>{o(a,new Audio),O(a,t(a).volume=t(j)),Ue(),w==="meting"?Re():(o(p,[...$e]),t(p).length>0?$t(t(p)[0]):kt("本地播放列表为空"))}),Pa(()=>{t(a)&&(t(a).pause(),O(a,t(a).src=""))}),za();var ue=st(),Ve=tt(ue);{var Xe=n=>{var S=vr(),U=tt(S);{var W=e=>{var m=lr(),_=i(m),B=i(_);f(B,{icon:"material-symbols:error",class:"text-xl flex-shrink-0"});var D=v(B,2),l=i(D,!0);r(D);var V=v(D,2),ct=i(V);f(ct,{icon:"material-symbols:close",class:"text-lg"}),r(V),r(_),r(m),Pt(()=>G(l,t(et))),h("click",V,Ke),Y(e,m)};z(U,e=>{t(at)&&e(W)})}var ft=v(U,2);let Ft;var R=i(ft);let ce;var Ge=i(R);{var Je=e=>{f(e,{icon:"eos-icons:loading",class:"text-white text-lg"})},Qe=e=>{var m=st(),_=tt(m);{var B=l=>{var V=or();Y(l,V)},D=l=>{f(l,{icon:"material-symbols:music-note",class:"text-white text-lg"})};z(_,l=>{t(x)?l(B):l(D,!1)},!0)}Y(e,m)};z(Ge,e=>{t(u)?e(Je):e(Qe,!1)})}r(R);var nt=v(R,2);let de;var ve=i(nt),Rt=i(ve),Wt=i(Rt);let fe;var pe=v(Wt,2),Ze=i(pe);{var ta=e=>{f(e,{icon:"eos-icons:loading",class:"text-white text-xl"})},ea=e=>{var m=st(),_=tt(m);{var B=l=>{f(l,{icon:"material-symbols:pause",class:"text-white text-xl"})},D=l=>{f(l,{icon:"material-symbols:play-arrow",class:"text-white text-xl"})};z(_,l=>{t(x)?l(B):l(D,!1)},!0)}Y(e,m)};z(Ze,e=>{t(u)?e(ta):e(ea,!1)})}r(pe),r(Rt);var Nt=v(Rt,2),Yt=i(Nt),aa=i(Yt,!0);r(Yt);var me=v(Yt,2),ra=i(me,!0);r(me),r(Nt);var be=v(Nt,2),Ct=i(be),ia=i(Ct);f(ia,{icon:"material-symbols:visibility-off",class:"text-lg"}),r(Ct);var qt=v(Ct,2),sa=i(qt);f(sa,{icon:"material-symbols:expand-less",class:"text-lg"}),r(qt),r(be),r(ve),r(nt);var Bt=v(nt,2);let ge;var Kt=i(Bt),Ot=i(Kt),he=i(Ot);let xe;r(Ot);var Ht=v(Ot,2),Ut=i(Ht),na=i(Ut,!0);r(Ut);var Vt=v(Ut,2),la=i(Vt,!0);r(Vt);var ye=v(Vt,2),oa=i(ye);r(ye),r(Ht);var _e=v(Ht,2),At=i(_e),ua=i(At);f(ua,{icon:"material-symbols:visibility-off",class:"text-lg"}),r(At);var Xt=v(At,2),ca=i(Xt);f(ca,{icon:"material-symbols:expand-more",class:"text-lg"}),r(Xt),r(_e),r(Kt);var Gt=v(Kt,2),lt=i(Gt),da=i(lt);r(lt),Te(lt,e=>o(Q,e),()=>t(Q)),r(Gt);var Jt=v(Gt,2),ot=i(Jt);let we;var va=i(ot);f(va,{icon:"material-symbols:shuffle",class:"text-lg"}),r(ot);var pt=v(ot,2),fa=i(pt);f(fa,{icon:"material-symbols:skip-previous",class:"text-xl"}),r(pt);var ut=v(pt,2);let Ee;var pa=i(ut);{var ma=e=>{f(e,{icon:"eos-icons:loading",class:"text-xl"})},ba=e=>{var m=st(),_=tt(m);{var B=l=>{f(l,{icon:"material-symbols:pause",class:"text-xl"})},D=l=>{f(l,{icon:"material-symbols:play-arrow",class:"text-xl"})};z(_,l=>{t(x)?l(B):l(D,!1)},!0)}Y(e,m)};z(pa,e=>{t(u)?e(ma):e(ba,!1)})}r(ut);var mt=v(ut,2),ga=i(mt);f(ga,{icon:"material-symbols:skip-next",class:"text-xl"}),r(mt);var Dt=v(mt,2);let ke;var ha=i(Dt);{var xa=e=>{f(e,{icon:"material-symbols:repeat-one",class:"text-lg"})},ya=e=>{var m=st(),_=tt(m);{var B=l=>{f(l,{icon:"material-symbols:repeat",class:"text-lg"})},D=l=>{f(l,{icon:"material-symbols:repeat",class:"text-lg opacity-50"})};z(_,l=>{t(g)===2?l(B):l(D,!1)},!0)}Y(e,m)};z(ha,e=>{t(g)===1?e(xa):e(ya,!1)})}r(Dt),r(Jt);var Fe=v(Jt,2),Lt=i(Fe),_a=i(Lt);{var wa=e=>{f(e,{icon:"material-symbols:volume-off",class:"text-lg"})},Ea=e=>{var m=st(),_=tt(m);{var B=l=>{f(l,{icon:"material-symbols:volume-down",class:"text-lg"})},D=l=>{f(l,{icon:"material-symbols:volume-up",class:"text-lg"})};z(_,l=>{t(j)<.5?l(B):l(D,!1)},!0)}Y(e,m)};z(_a,e=>{t(M)||t(j)===0?e(wa):e(Ea,!1)})}r(Lt);var rt=v(Lt,2),ka=i(rt);r(rt),Te(rt,e=>o(H,e),()=>t(H));var jt=v(rt,2);let Ce;var Fa=i(jt);f(Fa,{icon:"material-symbols:queue-music",class:"text-lg"}),r(jt),r(Fe),r(Bt);var Ca=v(Bt,2);{var Ba=e=>{var m=dr(),_=i(m),B=i(_),D=i(B,!0);r(B);var l=v(B,2),V=i(l);f(V,{icon:"material-symbols:close",class:"text-lg"}),r(l),r(_);var ct=v(_,2);Ga(ct,5,()=>t(p),Ja,(bt,Z,q)=>{var X=cr();let Mt;var gt=i(X),Aa=i(gt);{var Da=K=>{f(K,{icon:"material-symbols:graphic-eq",class:"text-[var(--primary)] animate-pulse"})},La=K=>{var St=st(),te=tt(St);{var ee=dt=>{f(dt,{icon:"material-symbols:pause",class:"text-[var(--primary)]"})},Ta=dt=>{var je=ur();je.textContent=q+1,Y(dt,je)};z(te,dt=>{q===t(y)?dt(ee):dt(Ta,!1)},!0)}Y(K,St)};z(Aa,K=>{q===t(y)&&t(x)?K(Da):K(La,!1)})}r(gt);var Qt=v(gt,2),Be=i(Qt);r(Qt);var Ae=v(Qt,2),Tt=i(Ae);let De;var ja=i(Tt,!0);r(Tt);var Zt=v(Tt,2);let Le;var Ma=i(Zt,!0);r(Zt),r(Ae),r(X),Pt((K,St,te,ee)=>{Mt=N(X,1,"playlist-item flex items-center gap-3 p-3 hover:bg-[var(--btn-plain-bg-hover)] cursor-pointer transition-colors",null,Mt,K),it(X,"aria-label",`播放 ${t(Z).title??""} - ${t(Z).artist??""}`),it(Be,"src",St),it(Be,"alt",t(Z).title),De=N(Tt,1,"font-medium truncate",null,De,te),G(ja,t(Z).title),Le=N(Zt,1,"text-sm text-[var(--content-meta)] truncate",null,Le,ee),G(Ma,t(Z).artist)},[()=>({"bg-[var(--btn-plain-bg)]":q===t(y),"text-[var(--primary)]":q===t(y)}),()=>Et(t(Z).cover),()=>({"text-[var(--primary)]":q===t(y),"text-90":q!==t(y)}),()=>({"text-[var(--primary)]":q===t(y)})]),h("click",X,()=>wt(q)),h("keydown",X,K=>{(K.key==="Enter"||K.key===" ")&&(K.preventDefault(),wt(q))}),Y(bt,X)}),r(ct),r(m),Pt(bt=>G(D,bt),[()=>Za(Qa.playlist)]),h("click",l,re),ir(3,m,()=>nr,()=>({duration:300,axis:"y"})),Y(e,m)};z(Ca,e=>{t(b)&&e(Ba)})}r(ft),Va(2),Pt((e,m,_,B,D,l,V,ct,bt,Z,q,X,Mt,gt)=>{Ft=N(ft,1,"music-player fixed bottom-4 right-4 z-50 transition-all duration-300 ease-in-out",null,Ft,e),ce=N(R,1,"orb-player w-12 h-12 bg-[var(--primary)] rounded-full shadow-lg cursor-pointer transition-all duration-500 ease-in-out flex items-center justify-center hover:scale-110 active:scale-95",null,ce,m),de=N(nt,1,"mini-player card-base bg-[var(--float-panel-bg)] shadow-xl rounded-2xl p-3 transition-all duration-500 ease-in-out",null,de,_),it(Wt,"src",B),fe=N(Wt,1,"w-full h-full object-cover transition-transform duration-300",null,fe,D),G(aa,t($).title),G(ra,t($).artist),ge=N(Bt,1,"expanded-player card-base bg-[var(--float-panel-bg)] shadow-xl rounded-2xl p-4 transition-all duration-500 ease-in-out",null,ge,l),it(he,"src",V),xe=N(he,1,"w-full h-full object-cover transition-transform duration-300",null,xe,ct),G(na,t($).title),G(la,t($).artist),G(oa,`${bt??""} / ${Z??""}`),it(lt,"aria-valuenow",t(k)>0?t(P)/t(k)*100:0),Me(da,`width: ${t(k)>0?t(P)/t(k)*100:0}%`),we=N(ot,1,"w-10 h-10 rounded-lg",null,we,q),ot.disabled=t(p).length<=1,pt.disabled=t(p).length<=1,Ee=N(ut,1,"btn-regular w-12 h-12 rounded-full",null,Ee,X),ut.disabled=t(u),mt.disabled=t(p).length<=1,ke=N(Dt,1,"w-10 h-10 rounded-lg",null,ke,Mt),it(rt,"aria-valuenow",t(j)*100),Me(ka,`width: ${t(j)*100}%`),Ce=N(jt,1,"btn-plain w-8 h-8 rounded-lg",null,Ce,gt)},[()=>({expanded:t(A),"hidden-mode":t(d)}),()=>({"opacity-0":!t(d),"scale-0":!t(d),"pointer-events-none":!t(d)}),()=>({"opacity-0":t(A)||t(d),"scale-95":t(A)||t(d),"pointer-events-none":t(A)||t(d)}),()=>Et(t($).cover),()=>({spinning:t(x)&&!t(u),"animate-pulse":t(u)}),()=>({"opacity-0":!t(A),"scale-95":!t(A),"pointer-events-none":!t(A)}),()=>Et(t($).cover),()=>({spinning:t(x)&&!t(u),"animate-pulse":t(u)}),()=>oe(t(P)),()=>oe(t(k)),()=>({"btn-regular":t(T),"btn-plain":!t(T)}),()=>({"opacity-50":t(u)}),()=>({"btn-regular":t(g)>0,"btn-plain":t(g)===0}),()=>({"text-[var(--primary)]":t(b)})]),h("click",R,_t),h("keydown",R,e=>{(e.key==="Enter"||e.key===" ")&&(e.preventDefault(),_t())}),h("click",Ct,Pe(_t)),h("click",qt,Pe(yt)),h("click",nt,yt),h("keydown",nt,e=>{(e.key==="Enter"||e.key===" ")&&(e.preventDefault(),yt())}),h("click",At,_t),h("click",Xt,yt),h("click",lt,Oe),h("keydown",lt,e=>{if(e.key==="Enter"||e.key===" "){e.preventDefault(),t(Q).getBoundingClientRect();const _=.5*t(k);t(a)&&(O(a,t(a).currentTime=_),o(P,_))}}),h("click",ot,Ne),h("click",pt,qe),h("click",ut,We),h("click",mt,It),h("click",Dt,Ye),h("click",Lt,le),h("click",rt,He),h("keydown",rt,e=>{(e.key==="Enter"||e.key===" ")&&(e.preventDefault(),e.key==="Enter"&&le())}),h("click",jt,re),Y(n,S)};z(Ve,n=>{n(Xe)})}Y(c,ue),Ha()}export{kr as default};
