window.SlideX23424=function(t){((t,e,o,r,s)=>{t(s,r),e(s,r),s.prev=o(s,-1,r),s.next=o(s,1,r)}).call(this,((t,e)=>{const o=t.section;if(t.viewBox=o,t.isConnected=o.isConnected,o&&"function"==typeof o.appendChild){const t=`${Math.random().toString(36).replace(/[^a-z]+/g,"").substring(2,3)}${(new Date).getTime()}`;o.setAttribute(t,"");const e=document.createElement("style");o.appendChild(e),e.innerHTML=`[${t}]::-ms-scrollbar { width: 0px; height: 0px; }[${t}]::-ms-scrollbar-track { background: #fff0; }[${t}]::-ms-scrollbar-thumb { background: #fff0; }[${t}]::-ms-scrollbar-thumb:hover { background: #fff0; }[${t}]::-moz-scrollbar { width: 0px; height: 0px; }[${t}]::-moz-scrollbar-track { background: #fff0; color: #fff0; }[${t}]::-moz-scrollbar-thumb { background: #fff0; color: #fff0; }[${t}]::-moz-scrollbar-thumb:hover { background: #fff0; color: #fff0; }[${t}]::-webkit-scrollbar { width: 0px; height: 0px; }[${t}]::-webkit-scrollbar-track { background: #fff0; }[${t}]::-webkit-scrollbar-thumb { background: #fff0; }[${t}]::-webkit-scrollbar-thumb:hover { background: #fff0; }`}t.list={},t.ordered=[],t.observer=new IntersectionObserver((e=>e.forEach((e=>t.list[e.target.dataset.id]=e))),{root:t.viewBox,threshold:t.threshold||[.9999,.5,1e-4]}),o.style.display="flex",o.style.flexDirection="row",o.style.overflow="scroll",o.onmousedown=function(e){t.isDown=!0,t.startX=e.pageX-o.offsetLeft,t.scrollLeft=o.scrollLeft};const r=function(){!t.scrolling&&t.isDown&&e(t),t.isDown=!1};o.onmouseleave=r,o.onmouseup=r,o.onmousemove=function(e){if(t.scrolling||!t.isDown)return;e.preventDefault(),t.event=e;const r=(e.pageX-o.offsetLeft-t.startX)*(parseFloat(t.scale)||1);o.scrollLeft=t.scrollLeft-r,t.walkX=r}}),((t,e)=>{const{viewBox:o=HTMLElement,observer:r,ordered:s=[]}=t;r.observe&&"function"==typeof o.appendChild&&(t.addItem=function(i){r.observe(i);const l=`${Math.random().toString(36).replace(/[^a-z]+/g,"").substring(2,3)}${Math.random().toString(36).substring(2,9)}`;s.push(l),i.dataset.id=l,o.contains(i)||o.appendChild(i),t.timeoutId&&clearTimeout(t.timeoutId),t.timeoutId=setTimeout((()=>e(t)),100)})}),((t,e,o)=>{const r="smooth";return()=>{if(!t.isDown){let s,i;const l=t.viewBox.scrollLeft;if(e>0)i=t.leftActived.target.offsetWidth,s=parseInt(i-l%i)||i;else{const e=t.rightActived.rootBounds.width;i=-t.rightActived.target.offsetWidth,s=-(parseInt(e%i+l%i)||i)}if(e<0&&s>0&&(s=0-s),t.scrolling){let o=s%i;e<0&&o>0&&(o=0-o),t.viewBox.scrollBy({left:i+o,behavior:r})}else t.viewBox.scrollBy({left:s,behavior:r}),t.viewBox.onscroll=()=>t.scrolling=!0,t.viewBox.onscrollend=()=>t.scrolling=!1;o(t)}}}),(t=>{t.listActived=t.ordered.filter((e=>t.list[e].isIntersecting)),t.leftActived=t.list[t.listActived[0]],t.rightActived=t.list[t.listActived[t.listActived.length-1]]}),t),this.addItem=t.addItem,this.prev=t.prev,this.next=t.next};