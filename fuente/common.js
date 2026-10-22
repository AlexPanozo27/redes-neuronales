/* Chispa: la neurona que guía los laboratorios */
function chispaSVG(mood){
  const m={happy:"M38 62 Q50 74 62 62",think:"M40 66 L60 64",wow:"M46 64 a4 5 0 1 0 8 0 a4 5 0 1 0 -8 0",sad:"M40 68 Q50 60 60 68"}[mood||"happy"];
  return `<svg viewBox="0 0 100 100" class="chispa-svg" aria-hidden="true">
  <g stroke="var(--lab)" stroke-width="5" stroke-linecap="round" fill="none">
   <path d="M22 38 L8 26 M8 26 L4 14 M8 26 L-2 28"/><path d="M20 66 L6 78 M6 78 L-2 76 M6 78 L4 90"/>
   <path d="M50 20 L50 6 M50 6 L42 0 M50 6 L58 0"/><path d="M80 58 L96 66 M96 66 L100 60"/></g>
  <circle cx="50" cy="52" r="32" fill="var(--lab)"/>
  <circle cx="50" cy="52" r="26" fill="var(--card)"/>
  <circle cx="40" cy="48" r="5" fill="var(--ink)"/><circle cx="60" cy="48" r="5" fill="var(--ink)"/>
  <circle cx="42" cy="46" r="1.6" fill="var(--card)"/><circle cx="62" cy="46" r="1.6" fill="var(--card)"/>
  <path d="${m}" stroke="var(--ink)" stroke-width="3.5" fill="${mood==="wow"?"var(--ink)":"none"}" stroke-linecap="round"/>
  <circle cx="32" cy="58" r="4" fill="var(--spark)" opacity=".55"/><circle cx="68" cy="58" r="4" fill="var(--spark)" opacity=".55"/>
  <path d="M74 18 l3 7 7 3 -7 3 -3 7 -3 -7 -7 -3 7 -3z" fill="var(--spark)"/></svg>`;}
document.querySelectorAll("[data-chispa]").forEach(el=>el.innerHTML=chispaSVG(el.dataset.chispa));

/* Guía con misiones: cada misión tiene un texto, una pista, una condición y una explicación al lograrla */
function Guide(root,{intro,missions,finale}){
  let i=-1,solved=false;
  root.classList.add("guide");
  root.innerHTML=`<div class="av"></div><div class="bubble" aria-live="polite"><span class="who"></span><div class="msg"></div>
    <div class="row" style="gap:8px"><button class="btn primary" data-next></button><button class="btn" data-hint>Dame una pista</button></div>
    <p class="hint" hidden></p><div class="missions"></div></div>`;
  const av=root.querySelector(".av"),who=root.querySelector(".who"),msg=root.querySelector(".msg"),nx=root.querySelector("[data-next]"),hb=root.querySelector("[data-hint]"),hint=root.querySelector(".hint"),ms=root.querySelector(".missions");
  function face(m,anim){av.innerHTML=chispaSVG(m);if(anim){av.classList.remove("wob");void av.offsetWidth;av.classList.add("wob");}}
  function chips(){ms.innerHTML=missions.map((_,k)=>`<span class="${k<i||(k===i&&solved)?"done":k===i?"now":""}">${k<i||(k===i&&solved)?"✓ ":""}Misión ${k+1}</span>`).join("");}
  function show(){hint.hidden=true;
    if(i<0){who.textContent="Chispa";msg.innerHTML=intro;nx.textContent="¡Empecemos!";nx.hidden=false;hb.hidden=true;face("happy");}
    else if(i>=missions.length){who.textContent="Laboratorio completo";msg.innerHTML=finale;nx.hidden=true;hb.hidden=true;face("wow",true);}
    else{const m=missions[i];who.textContent=`Misión ${i+1} de ${missions.length}`;msg.innerHTML=m.text;nx.hidden=true;hb.hidden=!m.hint;face("think");}
    chips();}
  nx.onclick=()=>{i++;solved=false;show();if(api.onMission)api.onMission(i);};
  hb.onclick=()=>{hint.hidden=!hint.hidden;hint.innerHTML=missions[i].hint;};
  const api={update(s){if(i<0||i>=missions.length||solved)return;const m=missions[i];
      if(m.done(s)){solved=true;who.textContent=`¡Misión ${i+1} lograda!`;msg.innerHTML=(typeof m.ok==="function"?m.ok(s):m.ok);
        nx.textContent=i===missions.length-1?"Terminar":"Siguiente misión";nx.hidden=false;hb.hidden=true;hint.hidden=true;face("happy",true);chips();}},
    get index(){return i;},onMission:null,start(){i=0;solved=false;show();}};
  show();return api;}

/* Glosario: toca una palabra subrayada para ver su significado */
(function(){let tip=null;
  function close(){if(tip){tip.remove();tip=null;}}
  document.addEventListener("click",e=>{const t=e.target.closest(".term");close();if(!t)return;
    tip=document.createElement("div");tip.className="tip";tip.setAttribute("role","tooltip");tip.textContent=t.dataset.def;document.body.appendChild(tip);
    const r=t.getBoundingClientRect(),w=tip.offsetWidth;let x=r.left+scrollX;x=Math.max(16,Math.min(x,innerWidth-w-16));
    tip.style.left=x+"px";tip.style.top=(r.bottom+scrollY+6)+"px";});
  document.addEventListener("keydown",e=>{if(e.key==="Escape")close();});
  addEventListener("resize",close);})();
const tok=v=>getComputedStyle(document.documentElement).getPropertyValue(v).trim();
function onTheme(fn){matchMedia("(prefers-color-scheme: dark)").addEventListener("change",fn);new MutationObserver(fn).observe(document.documentElement,{attributes:true,attributeFilter:["data-theme"]});}
