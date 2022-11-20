import 'package:demo_app/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

const kHtml = r'''
<div class="mw-parser-output">
   <div class="shortdescription nomobile noexcerpt noprint searchaux" style="display:none">American technology company</div>
   <div role="note" class="hatnote navigation-not-searchable">This article is about the company. For the search engine, see <a href="/wiki/Google_Search" title="Google Search">Google Search</a>. For other uses, see <a href="/wiki/Google_(disambiguation)" class="mw-disambig" title="Google (disambiguation)">Google (disambiguation)</a>.</div>
   <div role="note" class="hatnote navigation-not-searchable">Not to be confused with <a href="/wiki/Googol" title="Googol">Googol</a> or <a href="/wiki/Goggles" title="Goggles">Goggles</a>.</div>
   <p class="mw-empty-elt"></p>
   <table class="box-Merge_from plainlinks metadata ambox ambox-move" role="presentation">
      <tbody>
         <tr>
            <td class="mbox-image">
               <div style="width:52px"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Mergefrom.svg/50px-Mergefrom.svg.png" decoding="async" width="50" height="20" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Mergefrom.svg/75px-Mergefrom.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Mergefrom.svg/100px-Mergefrom.svg.png 2x" data-file-width="50" data-file-height="20"></div>
            </td>
            <td class="mbox-text">
               <div class="mbox-text-span">It has been suggested that <i><a href="/wiki/.google" title=".google">.google</a></i> be <a href="/wiki/Wikipedia:Merging" title="Wikipedia:Merging">merged</a> into this article. (<a href="/wiki/Talk:Google#Proposed_merge_of_.google_into_Google" title="Talk:Google">Discuss</a>)<small><i> Proposed since April 2021.</i></small></div>
            </td>
         </tr>
      </tbody>
   </table>
   <p class="mw-empty-elt">
   </p>
   <table class="infobox vcard">
      <caption class="infobox-title fn org">Google LLC</caption>
      <tbody>
         <tr>
            <td colspan="2" class="infobox-image logo">
               <a href="/wiki/File:Google_2015_logo.svg" class="image" title="Each letter of &quot;Google&quot; is colored (from left to right) in blue, red, yellow, blue, green, and red."><img alt="Each letter of &quot;Google&quot; is colored (from left to right) in blue, red, yellow, blue, green, and red." src="//upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/250px-Google_2015_logo.svg.png" decoding="async" width="250" height="85" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/375px-Google_2015_logo.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/500px-Google_2015_logo.svg.png 2x" data-file-width="272" data-file-height="92"></a>
               <div class="infobox-caption">Logo since 2015<sup class="plainlinks noexcerpt noprint asof-tag update" style="display:none;"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Google&amp;action=edit">[update]</a></sup></div>
            </td>
         </tr>
         <tr>
            <td colspan="2" class="infobox-image logo">
               <a href="/wiki/File:Googleplex_HQ_(cropped).jpg" class="image"><img alt="Googleplex HQ (cropped).jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/3/32/Googleplex_HQ_%28cropped%29.jpg/250px-Googleplex_HQ_%28cropped%29.jpg" decoding="async" width="250" height="183" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/3/32/Googleplex_HQ_%28cropped%29.jpg/375px-Googleplex_HQ_%28cropped%29.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/3/32/Googleplex_HQ_%28cropped%29.jpg/500px-Googleplex_HQ_%28cropped%29.jpg 2x" data-file-width="3024" data-file-height="2212"></a>
               <div class="infobox-caption">Google's headquarters, the <a href="/wiki/Googleplex" title="Googleplex">Googleplex</a></div>
            </td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">Formerly</th>
            <td class="infobox-data nickname" style="line-height: 1.35em;">Google Inc. (1998–2017)</td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">Type</th>
            <td class="infobox-data category" style="line-height: 1.35em;"><a href="/wiki/Subsidiary" title="Subsidiary">Subsidiary</a> (<a href="/wiki/Limited_liability_company" title="Limited liability company">LLC</a>)</td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">Industry</th>
            <td class="infobox-data category" style="line-height: 1.35em;">
               <div class="plainlist">
                  <ul>
                     <li><a href="/wiki/Internet" title="Internet">Internet</a></li>
                     <li><a href="/wiki/Cloud_computing" title="Cloud computing">Cloud computing</a></li>
                     <li><a href="/wiki/Computer_software" class="mw-redirect" title="Computer software">Computer software</a></li>
                     <li><a href="/wiki/Computer_hardware" title="Computer hardware">Computer hardware</a></li>
                     <li><a href="/wiki/Artificial_intelligence" title="Artificial intelligence">Artificial intelligence</a></li>
                     <li><a href="/wiki/Advertising" title="Advertising">Advertising</a></li>
                  </ul>
               </div>
            </td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">Founded</th>
            <td class="infobox-data" style="line-height: 1.35em;">September&nbsp;4, 1998<span class="noprint">; 22 years ago</span><span style="display:none">&nbsp;(<span class="bday dtstart published updated">1998-09-04</span>)</span><sup id="cite_ref-5" class="reference"><a href="#cite_note-5">[a]</a></sup> in <a href="/wiki/Menlo_Park,_California" title="Menlo Park, California">Menlo Park</a>, California, United States</td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">Founders</th>
            <td class="infobox-data agent" style="line-height: 1.35em;">
               <div class="plainlist">
                  <ul>
                     <li><a href="/wiki/Larry_Page" title="Larry Page">Larry Page</a></li>
                     <li><a href="/wiki/Sergey_Brin" title="Sergey Brin">Sergey Brin</a></li>
                  </ul>
               </div>
            </td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">Headquarters</th>
            <td class="infobox-data label" style="line-height: 1.35em;">
               <div class="plainlist">
                  <ul>
                     <li><a href="/wiki/Googleplex" title="Googleplex">1600 Amphitheatre Parkway</a>, <a href="/wiki/Mountain_View,_California" title="Mountain View, California">Mountain View, California</a>, United States</li>
                     <li><a href="/wiki/Queenstown,_Singapore" title="Queenstown, Singapore">Queenstown</a>, <a href="/wiki/Singapore" title="Singapore">Singapore</a> (<a href="/wiki/Asia-Pacific" title="Asia-Pacific">Asia-Pacific</a>)<sup id="cite_ref-6" class="reference"><a href="#cite_note-6">[5]</a></sup></li>
                  </ul>
               </div>
            </td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">
               <div style="display:inline-block; padding:0.1em 0;line-height:1.2em;">Area served</div>
            </th>
            <td class="infobox-data" style="line-height: 1.35em;">Worldwide</td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">
               <div style="display:inline-block; padding:0.1em 0;line-height:1.2em;">Key people</div>
            </th>
            <td class="infobox-data agent" style="line-height: 1.35em;">
               <div class="plainlist">
                  <ul>
                     <li><a href="/wiki/Sundar_Pichai" title="Sundar Pichai">Sundar Pichai</a> (<a href="/wiki/Chief_executive_officer" title="Chief executive officer">CEO</a>)</li>
                     <li><a href="/wiki/Ruth_Porat" title="Ruth Porat">Ruth Porat</a> (<a href="/wiki/Chief_financial_officer" title="Chief financial officer">CFO</a>)</li>
                  </ul>
               </div>
            </td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">Products</th>
            <td class="infobox-data" style="line-height: 1.35em;"><a href="/wiki/List_of_Google_products" title="List of Google products">List of products</a></td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">Revenue</th>
            <td class="infobox-data" style="line-height: 1.35em;">182,527,000,000 United States dollar (2020)&nbsp;<span class="penicon autoconfirmed-show"><a href="https://www.wikidata.org/wiki/Q95?uselang=en#P2139" title="Edit this on Wikidata"><img alt="Edit this on Wikidata" src="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/10px-OOjs_UI_icon_edit-ltr-progressive.svg.png" decoding="async" width="10" height="10" style="vertical-align: text-top" srcset="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/15px-OOjs_UI_icon_edit-ltr-progressive.svg.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/20px-OOjs_UI_icon_edit-ltr-progressive.svg.png 2x" data-file-width="20" data-file-height="20"></a></span></td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">
               <div style="display:inline-block; padding:0.1em 0;line-height:1.2em;"><a href="/wiki/Earnings_before_interest_and_taxes" title="Earnings before interest and taxes">Operating income</a></div>
            </th>
            <td class="infobox-data" style="line-height: 1.35em;">41,224,000,000 United States dollar (2020)&nbsp;<span class="penicon autoconfirmed-show"><a href="https://www.wikidata.org/wiki/Q95?uselang=en#P3362" title="Edit this on Wikidata"><img alt="Edit this on Wikidata" src="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/10px-OOjs_UI_icon_edit-ltr-progressive.svg.png" decoding="async" width="10" height="10" style="vertical-align: text-top" srcset="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/15px-OOjs_UI_icon_edit-ltr-progressive.svg.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/20px-OOjs_UI_icon_edit-ltr-progressive.svg.png 2x" data-file-width="20" data-file-height="20"></a></span></td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">
               <div style="display:inline-block; padding:0.1em 0;line-height:1.2em;"><a href="/wiki/Net_income" title="Net income">Net income</a></div>
            </th>
            <td class="infobox-data" style="line-height: 1.35em;">40,269,000,000 United States dollar (2020)&nbsp;<span class="penicon autoconfirmed-show"><a href="https://www.wikidata.org/wiki/Q95?uselang=en#P2295" title="Edit this on Wikidata"><img alt="Edit this on Wikidata" src="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/10px-OOjs_UI_icon_edit-ltr-progressive.svg.png" decoding="async" width="10" height="10" style="vertical-align: text-top" srcset="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/15px-OOjs_UI_icon_edit-ltr-progressive.svg.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/20px-OOjs_UI_icon_edit-ltr-progressive.svg.png 2x" data-file-width="20" data-file-height="20"></a></span></td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;"><span class="nowrap"><a href="/wiki/Asset" title="Asset">Total assets</a></span></th>
            <td class="infobox-data" style="line-height: 1.35em;">319,616,000,000 United States dollar (2020)&nbsp;<span class="penicon autoconfirmed-show"><a href="https://www.wikidata.org/wiki/Q95?uselang=en#P2403" title="Edit this on Wikidata"><img alt="Edit this on Wikidata" src="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/10px-OOjs_UI_icon_edit-ltr-progressive.svg.png" decoding="async" width="10" height="10" style="vertical-align: text-top" srcset="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/15px-OOjs_UI_icon_edit-ltr-progressive.svg.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/20px-OOjs_UI_icon_edit-ltr-progressive.svg.png 2x" data-file-width="20" data-file-height="20"></a></span></td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">
               <div style="display:inline-block; padding:0.1em 0;line-height:1.2em;">Number of employees</div>
            </th>
            <td class="infobox-data" style="line-height: 1.35em;">135,301 (2020)&nbsp;<span class="penicon autoconfirmed-show"><a href="https://www.wikidata.org/wiki/Q95?uselang=en#P1128" title="Edit this on Wikidata"><img alt="Edit this on Wikidata" src="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/10px-OOjs_UI_icon_edit-ltr-progressive.svg.png" decoding="async" width="10" height="10" style="vertical-align: text-top" srcset="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/15px-OOjs_UI_icon_edit-ltr-progressive.svg.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/20px-OOjs_UI_icon_edit-ltr-progressive.svg.png 2x" data-file-width="20" data-file-height="20"></a></span></td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;"><a href="/wiki/Parent_company" title="Parent company">Parent</a></th>
            <td class="infobox-data" style="line-height: 1.35em;"><a href="/wiki/Alphabet_Inc." title="Alphabet Inc.">Alphabet Inc.</a></td>
         </tr>
         <tr>
            <th scope="row" class="infobox-label" style="padding-right: 0.5em;">Website</th>
            <td class="infobox-data" style="line-height: 1.35em;"><span class="url"><a rel="nofollow" class="external text" href="https://www.google.com/">google.com</a></span></td>
         </tr>
         <tr>
            <td colspan="2" class="infobox-below" style="line-height: 1.35em;"><b>Footnotes&nbsp;/ references</b><br><sup id="cite_ref-7" class="reference"><a href="#cite_note-7">[6]</a></sup><sup id="cite_ref-8" class="reference"><a href="#cite_note-8">[7]</a></sup><sup id="cite_ref-9" class="reference"><a href="#cite_note-9">[8]</a></sup><sup id="cite_ref-:0_10-0" class="reference"><a href="#cite_note-:0-10">[9]</a></sup></td>
         </tr>
      </tbody>
   </table>
   <div class="thumb tright">
      <div class="thumbinner" style="width:222px;">
         <a href="/wiki/File:Schmidt-Brin-Page-20080520.jpg" class="image"><img alt="Eric Schmidt, Sergey Brin, and Larry Page sitting together" src="//upload.wikimedia.org/wikipedia/commons/thumb/6/69/Schmidt-Brin-Page-20080520.jpg/220px-Schmidt-Brin-Page-20080520.jpg" decoding="async" width="220" height="167" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/6/69/Schmidt-Brin-Page-20080520.jpg/330px-Schmidt-Brin-Page-20080520.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/6/69/Schmidt-Brin-Page-20080520.jpg/440px-Schmidt-Brin-Page-20080520.jpg 2x" data-file-width="2916" data-file-height="2217"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Schmidt-Brin-Page-20080520.jpg" class="internal" title="Enlarge"></a></div>
            Then-CEO, and former Chairman of Google <a href="/wiki/Eric_Schmidt" title="Eric Schmidt">Eric Schmidt</a> with cofounders <a href="/wiki/Sergey_Brin" title="Sergey Brin">Sergey Brin</a> and <a href="/wiki/Larry_Page" title="Larry Page">Larry Page</a> (left to right) in 2008.
         </div>
      </div>
   </div>
   <p><b>Google LLC</b> is an American <a href="/wiki/Multinational_corporation" title="Multinational corporation">multinational</a> <a href="/wiki/Technology_company" title="Technology company">technology company</a> that specializes in <a href="/wiki/Internet" title="Internet">Internet</a>-related services and products, which include <a href="/wiki/Online_advertising" title="Online advertising">online advertising technologies</a>, a <a href="/wiki/Search_engine" title="Search engine">search engine</a>, <a href="/wiki/Cloud_computing" title="Cloud computing">cloud computing</a>, software, and hardware. It is considered one of the five <a href="/wiki/Big_Tech" title="Big Tech">Big Tech</a> companies alongside <a href="/wiki/Amazon_(company)" title="Amazon (company)">Amazon</a>, <a href="/wiki/Facebook,_Inc." title="Facebook, Inc.">Facebook</a>, <a href="/wiki/Apple_Inc." title="Apple Inc.">Apple</a>, and <a href="/wiki/Microsoft" title="Microsoft">Microsoft</a>.<sup id="cite_ref-11" class="reference"><a href="#cite_note-11">[10]</a></sup><sup id="cite_ref-12" class="reference"><a href="#cite_note-12">[11]</a></sup><sup id="cite_ref-13" class="reference"><a href="#cite_note-13">[12]</a></sup></p>
   <p>Google was founded in September 1998 by <a href="/wiki/Larry_Page" title="Larry Page">Larry Page</a> and <a href="/wiki/Sergey_Brin" title="Sergey Brin">Sergey Brin</a> while they were Ph.D. students at <a href="/wiki/Stanford_University" title="Stanford University">Stanford University</a> in <a href="/wiki/California" title="California">California</a>. Together they own about 14% of its shares and control 56% of the stockholder voting power through super-voting stock. Google was incorporated in California on September 4, 1998. Google was then reincorporated in Delaware on October 22, 2002.<sup id="cite_ref-14" class="reference"><a href="#cite_note-14">[13]</a></sup> In July 2003, Google moved to its headquarters in <a href="/wiki/Mountain_View,_California" title="Mountain View, California">Mountain View, California</a>, nicknamed the <a href="/wiki/Googleplex" title="Googleplex">Googleplex</a>. The company became a <a href="/wiki/Public_company" title="Public company">public company</a> via an <a href="/wiki/Initial_public_offering" title="Initial public offering">initial public offering</a> (IPO) on August 19, 2004. In October 2015, Google reorganized as a subsidiary of a conglomerate called <a href="/wiki/Alphabet_Inc." title="Alphabet Inc.">Alphabet Inc.</a> Google is Alphabet's largest subsidiary and is a <a href="/wiki/Holding_company" title="Holding company">holding company</a> for Alphabet's Internet interests. <a href="/wiki/Sundar_Pichai" title="Sundar Pichai">Sundar Pichai</a> was appointed CEO of Google, replacing Larry Page, who became the CEO of Alphabet. In 2021, the <a href="/wiki/Alphabet_Workers_Union" title="Alphabet Workers Union">Alphabet Workers Union</a> was founded, mainly composed of Google employees.<sup id="cite_ref-15" class="reference"><a href="#cite_note-15">[14]</a></sup></p>
   <p>The company's rapid growth since incorporation has included products, acquisitions, and partnerships beyond Google's core <a href="/wiki/Search_engine" title="Search engine">search engine</a>, (<a href="/wiki/Google_Search" title="Google Search">Google Search</a>). It offers services designed for work and productivity (<a href="/wiki/Google_Docs" title="Google Docs">Google Docs</a>, <a href="/wiki/Google_Sheets" title="Google Sheets">Google Sheets</a>, and <a href="/wiki/Google_Slides" title="Google Slides">Google Slides</a>), email (<a href="/wiki/Gmail" title="Gmail">Gmail</a>), scheduling and time management (<a href="/wiki/Google_Calendar" title="Google Calendar">Google Calendar</a>), cloud storage (<a href="/wiki/Google_Drive" title="Google Drive">Google Drive</a>), instant messaging and video chat (<a href="/wiki/Google_Duo" title="Google Duo">Google Duo</a>, <a href="/wiki/Hangouts" class="mw-redirect" title="Hangouts">Hangouts</a>, <a href="/wiki/Google_Chat" title="Google Chat">Google Chat</a>, and <a href="/wiki/Google_Meet" title="Google Meet">Google Meet</a>), language translation (<a href="/wiki/Google_Translate" title="Google Translate">Google Translate</a>), mapping and navigation (<a href="/wiki/Google_Maps" title="Google Maps">Google Maps</a>, <a href="/wiki/Waze" title="Waze">Waze</a>, <a href="/wiki/Google_Earth" title="Google Earth">Google Earth</a>, and <a href="/wiki/Street_View" class="mw-redirect" title="Street View">Street View</a>), podcast hosting (<a href="/wiki/Google_Podcasts" title="Google Podcasts">Google Podcasts</a>), video sharing (<a href="/wiki/YouTube" title="YouTube">YouTube</a>), blog publishing (<a href="/wiki/Blogger_(service)" title="Blogger (service)">Blogger</a>), note-taking (<a href="/wiki/Google_Keep" title="Google Keep">Google Keep</a> and <a href="/wiki/Jamboard" title="Jamboard">Jamboard</a>), and photo organizing and editing (<a href="/wiki/Google_Photos" title="Google Photos">Google Photos</a>). The company leads the development of the <a href="/wiki/Android_(operating_system)" title="Android (operating system)">Android</a> mobile operating system, the <a href="/wiki/Google_Chrome" title="Google Chrome">Google Chrome</a> web browser, and <a href="/wiki/Chrome_OS" title="Chrome OS">Chrome OS</a>, a lightweight operating system based on the Chrome browser. Google has moved increasingly into hardware; from 2010 to 2015, it partnered with major electronics manufacturers in the production of its <a href="/wiki/Google_Nexus" title="Google Nexus">Google Nexus</a> devices, and it released multiple hardware products in October 2016, including the <a href="/wiki/Pixel_(smartphone)" class="mw-redirect" title="Pixel (smartphone)">Google Pixel</a> line of smartphones, <a href="/wiki/Google_Home" class="mw-redirect" title="Google Home">Google Home</a> smart speaker, <a href="/wiki/Google_Wifi_(router)" class="mw-redirect" title="Google Wifi (router)">Google Wifi</a> mesh wireless router, and <a href="/wiki/Google_Daydream" title="Google Daydream">Google Daydream</a> virtual reality headset. Google has also experimented with becoming an Internet carrier (<a href="/wiki/Google_Fiber" title="Google Fiber">Google Fiber</a>, <a href="/wiki/Google_Fi" title="Google Fi">Google Fi</a>, and <a href="/wiki/Google_Station" title="Google Station">Google Station</a>).<sup id="cite_ref-16" class="reference"><a href="#cite_note-16">[15]</a></sup></p>
   <p>Google.com is the most visited website worldwide. Several other Google-owned websites also are on the <a href="/wiki/List_of_most_popular_websites" title="List of most popular websites">list of most popular websites</a>, including <a href="/wiki/YouTube" title="YouTube">YouTube</a> and <a href="/wiki/Blogger_(service)" title="Blogger (service)">Blogger</a>.<sup id="cite_ref-topsites_17-0" class="reference"><a href="#cite_note-topsites-17">[16]</a></sup></p>
   <p>On the <a href="/wiki/List_of_most_valuable_brands" title="List of most valuable brands">list of most valuable brands</a>, Google is ranked second by <a href="/wiki/Forbes" title="Forbes">Forbes</a><sup id="cite_ref-18" class="reference"><a href="#cite_note-18">[17]</a></sup> and fourth by Interbrand.<sup id="cite_ref-19" class="reference"><a href="#cite_note-19">[18]</a></sup> It has received significant <a href="/wiki/Criticism_of_Google" title="Criticism of Google">criticism</a> involving issues such as <a href="/wiki/Privacy_concerns_regarding_Google" title="Privacy concerns regarding Google">privacy concerns</a>, tax avoidance, antitrust, <a href="/wiki/Censorship_by_Google" title="Censorship by Google">censorship</a>, and <a href="/wiki/Search_neutrality" title="Search neutrality">search neutrality</a>.</p>
   <div id="toc" class="toc" role="navigation" aria-labelledby="mw-toc-heading">
      <input type="checkbox" role="button" id="toctogglecheckbox" class="toctogglecheckbox" style="display:none">
      <div class="toctitle" lang="en" dir="ltr">
         <h2 id="mw-toc-heading">Contents</h2>
         <span class="toctogglespan"><label class="toctogglelabel" for="toctogglecheckbox"></label></span>
      </div>
      <ul>
         <li class="toclevel-1 tocsection-1">
            <a href="#History"><span class="tocnumber">1</span> <span class="toctext">History</span></a>
            <ul>
               <li class="toclevel-2 tocsection-2"><a href="#Early_years"><span class="tocnumber">1.1</span> <span class="toctext">Early years</span></a></li>
               <li class="toclevel-2 tocsection-3"><a href="#Growth"><span class="tocnumber">1.2</span> <span class="toctext">Growth</span></a></li>
               <li class="toclevel-2 tocsection-4"><a href="#Initial_public_offering"><span class="tocnumber">1.3</span> <span class="toctext">Initial public offering</span></a></li>
               <li class="toclevel-2 tocsection-5"><a href="#2012_onward"><span class="tocnumber">1.4</span> <span class="toctext">2012 onward</span></a></li>
            </ul>
         </li>
         <li class="toclevel-1 tocsection-6">
            <a href="#Products_and_services"><span class="tocnumber">2</span> <span class="toctext">Products and services</span></a>
            <ul>
               <li class="toclevel-2 tocsection-7"><a href="#Search_engine"><span class="tocnumber">2.1</span> <span class="toctext">Search engine</span></a></li>
               <li class="toclevel-2 tocsection-8"><a href="#Advertising"><span class="tocnumber">2.2</span> <span class="toctext">Advertising</span></a></li>
               <li class="toclevel-2 tocsection-9">
                  <a href="#Consumer_services"><span class="tocnumber">2.3</span> <span class="toctext">Consumer services</span></a>
                  <ul>
                     <li class="toclevel-3 tocsection-10"><a href="#Web-based_services"><span class="tocnumber">2.3.1</span> <span class="toctext">Web-based services</span></a></li>
                     <li class="toclevel-3 tocsection-11"><a href="#Software"><span class="tocnumber">2.3.2</span> <span class="toctext">Software</span></a></li>
                     <li class="toclevel-3 tocsection-12"><a href="#Hardware"><span class="tocnumber">2.3.3</span> <span class="toctext">Hardware</span></a></li>
                  </ul>
               </li>
               <li class="toclevel-2 tocsection-13"><a href="#Enterprise_services"><span class="tocnumber">2.4</span> <span class="toctext">Enterprise services</span></a></li>
               <li class="toclevel-2 tocsection-14"><a href="#Internet_services"><span class="tocnumber">2.5</span> <span class="toctext">Internet services</span></a></li>
               <li class="toclevel-2 tocsection-15"><a href="#Other_products"><span class="tocnumber">2.6</span> <span class="toctext">Other products</span></a></li>
            </ul>
         </li>
         <li class="toclevel-1 tocsection-16">
            <a href="#Corporate_affairs"><span class="tocnumber">3</span> <span class="toctext">Corporate affairs</span></a>
            <ul>
               <li class="toclevel-2 tocsection-17"><a href="#Stock_price_performance_and_quarterly_earnings"><span class="tocnumber">3.1</span> <span class="toctext">Stock price performance and quarterly earnings</span></a></li>
               <li class="toclevel-2 tocsection-18"><a href="#Tax_avoidance_strategies"><span class="tocnumber">3.2</span> <span class="toctext">Tax avoidance strategies</span></a></li>
               <li class="toclevel-2 tocsection-19"><a href="#Corporate_identity"><span class="tocnumber">3.3</span> <span class="toctext">Corporate identity</span></a></li>
               <li class="toclevel-2 tocsection-20"><a href="#Workplace_culture"><span class="tocnumber">3.4</span> <span class="toctext">Workplace culture</span></a></li>
               <li class="toclevel-2 tocsection-21"><a href="#Office_locations"><span class="tocnumber">3.5</span> <span class="toctext">Office locations</span></a></li>
               <li class="toclevel-2 tocsection-22"><a href="#Infrastructure"><span class="tocnumber">3.6</span> <span class="toctext">Infrastructure</span></a></li>
               <li class="toclevel-2 tocsection-23"><a href="#Environment"><span class="tocnumber">3.7</span> <span class="toctext">Environment</span></a></li>
               <li class="toclevel-2 tocsection-24"><a href="#Philanthropy"><span class="tocnumber">3.8</span> <span class="toctext">Philanthropy</span></a></li>
            </ul>
         </li>
         <li class="toclevel-1 tocsection-25">
            <a href="#Criticism_and_controversies"><span class="tocnumber">4</span> <span class="toctext">Criticism and controversies</span></a>
            <ul>
               <li class="toclevel-2 tocsection-26"><a href="#Anti-trust,_privacy,_and_other_litigation"><span class="tocnumber">4.1</span> <span class="toctext">Anti-trust, privacy, and other litigation</span></a></li>
            </ul>
         </li>
         <li class="toclevel-1 tocsection-27"><a href="#See_also"><span class="tocnumber">5</span> <span class="toctext">See also</span></a></li>
         <li class="toclevel-1 tocsection-28"><a href="#Notes"><span class="tocnumber">6</span> <span class="toctext">Notes</span></a></li>
         <li class="toclevel-1 tocsection-29"><a href="#References"><span class="tocnumber">7</span> <span class="toctext">References</span></a></li>
         <li class="toclevel-1 tocsection-30"><a href="#Further_reading"><span class="tocnumber">8</span> <span class="toctext">Further reading</span></a></li>
         <li class="toclevel-1 tocsection-31"><a href="#External_links"><span class="tocnumber">9</span> <span class="toctext">External links</span></a></li>
      </ul>
   </div>
   <h2><span class="mw-headline" id="History">History</span></h2>
   <div role="note" class="hatnote navigation-not-searchable">Main articles: <a href="/wiki/History_of_Google" title="History of Google">History of Google</a> and <a href="/wiki/List_of_mergers_and_acquisitions_by_Alphabet" title="List of mergers and acquisitions by Alphabet">List of mergers and acquisitions by Alphabet</a></div>
   <div role="note" class="hatnote navigation-not-searchable">See also: <a href="/wiki/Alphabet_Inc." title="Alphabet Inc.">Alphabet Inc.</a></div>
   <h3><span class="mw-headline" id="Early_years">Early years</span></h3>
   <div class="thumb tleft">
      <div class="thumbinner" style="width:222px;">
         <a href="/wiki/File:Google_page_brin.jpg" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Google_page_brin.jpg/220px-Google_page_brin.jpg" decoding="async" width="220" height="153" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Google_page_brin.jpg/330px-Google_page_brin.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Google_page_brin.jpg/440px-Google_page_brin.jpg 2x" data-file-width="1541" data-file-height="1073"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Google_page_brin.jpg" class="internal" title="Enlarge"></a></div>
            <a href="/wiki/Larry_Page" title="Larry Page">Larry Page</a> and <a href="/wiki/Sergey_Brin" title="Sergey Brin">Sergey Brin</a> in 2003
         </div>
      </div>
   </div>
   <p>Google began in January 1996 as a research project by <a href="/wiki/Larry_Page" title="Larry Page">Larry Page</a> and <a href="/wiki/Sergey_Brin" title="Sergey Brin">Sergey Brin</a> when they were both PhD students at <a href="/wiki/Stanford_University" title="Stanford University">Stanford University</a> in <a href="/wiki/Stanford,_California" title="Stanford, California">Stanford, California</a>.<sup id="cite_ref-milestones_20-0" class="reference"><a href="#cite_note-milestones-20">[19]</a></sup> The project initially involved an unofficial "third founder", Scott Hassan, the original lead programmer who wrote much of the code for the original <a href="/wiki/Google_Search" title="Google Search">Google Search</a> engine, but he left before Google was officially founded as a company;<sup id="cite_ref-vanityfair_21-0" class="reference"><a href="#cite_note-vanityfair-21">[20]</a></sup><sup id="cite_ref-22" class="reference"><a href="#cite_note-22">[21]</a></sup> Hassan went on to pursue a career in <a href="/wiki/Robotics" title="Robotics">robotics</a> and founded the company <a href="/wiki/Willow_Garage" title="Willow Garage">Willow Garage</a> in 2006.<sup id="cite_ref-23" class="reference"><a href="#cite_note-23">[22]</a></sup><sup id="cite_ref-24" class="reference"><a href="#cite_note-24">[23]</a></sup></p>
   <p>While conventional search engines ranked results by counting how many times the search terms appeared on the page, they theorized about a better system that analyzed the relationships among websites.<sup id="cite_ref-25" class="reference"><a href="#cite_note-25">[24]</a></sup> They called this algorithm <a href="/wiki/PageRank" title="PageRank">PageRank</a>; it determined a website's <a href="/wiki/Relevance_(information_retrieval)" title="Relevance (information retrieval)">relevance</a> by the number of pages, and the importance of those pages that linked back to the original site.<sup id="cite_ref-26" class="reference"><a href="#cite_note-26">[25]</a></sup><sup id="cite_ref-27" class="reference"><a href="#cite_note-27">[26]</a></sup> Page told his ideas to Hassan, who began writing the code to implement Page's ideas.<sup id="cite_ref-vanityfair_21-1" class="reference"><a href="#cite_note-vanityfair-21">[20]</a></sup></p>
   <p>Page and Brin originally nicknamed the new search engine "<a href="/wiki/BackRub_(search_engine)" class="mw-redirect" title="BackRub (search engine)">BackRub</a>", because the system checked backlinks to estimate the importance of a site.<sup id="cite_ref-28" class="reference"><a href="#cite_note-28">[27]</a></sup><sup id="cite_ref-29" class="reference"><a href="#cite_note-29">[28]</a></sup><sup id="cite_ref-30" class="reference"><a href="#cite_note-30">[29]</a></sup> Hassan as well as Alan Steremberg were cited by Page and Brin as being critical to the development of Google. <a href="/wiki/Rajeev_Motwani" title="Rajeev Motwani">Rajeev Motwani</a> and <a href="/wiki/Terry_Winograd" title="Terry Winograd">Terry Winograd</a> later co-authored with Page and Brin the first paper about the project, describing PageRank and the initial prototype of the Google search engine, published in 1998. <a href="/wiki/H%C3%A9ctor_Garc%C3%ADa-Molina" title="Héctor García-Molina">Héctor García-Molina</a> and <a href="/wiki/Jeff_Ullman" class="mw-redirect" title="Jeff Ullman">Jeff Ullman</a> were also cited as contributors to the project.<sup id="cite_ref-originalpaper_31-0" class="reference"><a href="#cite_note-originalpaper-31">[30]</a></sup> PageRank was influenced by a similar page-ranking and site-scoring algorithm earlier used for <a href="/wiki/RankDex" class="mw-redirect" title="RankDex">RankDex</a>, developed by <a href="/wiki/Robin_Li" title="Robin Li">Robin Li</a> in 1996, with Larry Page's PageRank patent including a citation to Li's earlier RankDex patent; Li later went on to create the Chinese search engine <a href="/wiki/Baidu" title="Baidu">Baidu</a>.<sup id="cite_ref-32" class="reference"><a href="#cite_note-32">[31]</a></sup><sup id="cite_ref-33" class="reference"><a href="#cite_note-33">[32]</a></sup><sup id="cite_ref-34" class="reference"><a href="#cite_note-34">[33]</a></sup></p>
   <p>Eventually, they changed the name to Google; the name of the search engine originated from a misspelling of the word "<a href="/wiki/Googol" title="Googol">googol</a>",<sup id="cite_ref-35" class="reference"><a href="#cite_note-35">[34]</a></sup><sup id="cite_ref-36" class="reference"><a href="#cite_note-36">[35]</a></sup> the number 1 followed by 100 zeros, which was picked to signify that the search engine was intended to provide large quantities of information.<sup id="cite_ref-37" class="reference"><a href="#cite_note-37">[36]</a></sup></p>
   <div class="thumb tright">
      <div class="thumbinner" style="width:252px;">
         <a href="/wiki/File:Google1998.png" class="image"><img alt="Google's homepage in 1998" src="//upload.wikimedia.org/wikipedia/en/thumb/b/b7/Google1998.png/250px-Google1998.png" decoding="async" width="250" height="139" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/en/thumb/b/b7/Google1998.png/375px-Google1998.png 1.5x, //upload.wikimedia.org/wikipedia/en/b/b7/Google1998.png 2x" data-file-width="423" data-file-height="235"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Google1998.png" class="internal" title="Enlarge"></a></div>
            Google's original homepage had a simple design because the company founders had little experience in <a href="/wiki/HTML" title="HTML">HTML</a>, the <a href="/wiki/Markup_language" title="Markup language">markup language</a> used for designing web pages.<sup id="cite_ref-38" class="reference"><a href="#cite_note-38">[37]</a></sup>
         </div>
      </div>
   </div>
   <p>The domain name <code>www.google.com</code> was registered on September 15, 1997,<sup id="cite_ref-39" class="reference"><a href="#cite_note-39">[38]</a></sup> and the company was incorporated on September 4, 1998. It was based in the garage of a friend (<a href="/wiki/Susan_Wojcicki" title="Susan Wojcicki">Susan Wojcicki</a><sup id="cite_ref-milestones_20-1" class="reference"><a href="#cite_note-milestones-20">[19]</a></sup>) in <a href="/wiki/Menlo_Park,_California" title="Menlo Park, California">Menlo Park, California</a>. <a href="/wiki/Craig_Silverstein" title="Craig Silverstein">Craig Silverstein</a>, a fellow PhD student at Stanford, was hired as the first employee.<sup id="cite_ref-milestones_20-2" class="reference"><a href="#cite_note-milestones-20">[19]</a></sup><sup id="cite_ref-40" class="reference"><a href="#cite_note-40">[39]</a></sup><sup id="cite_ref-41" class="reference"><a href="#cite_note-41">[40]</a></sup></p>
   <p>Google was initially funded by an August 1998 contribution of $100,000 from <a href="/wiki/Andy_Bechtolsheim" title="Andy Bechtolsheim">Andy Bechtolsheim</a>, co-founder of <a href="/wiki/Sun_Microsystems" title="Sun Microsystems">Sun Microsystems</a>; the money was given before Google was incorporated.<sup id="cite_ref-42" class="reference"><a href="#cite_note-42">[41]</a></sup><sup id="cite_ref-Bechtolsheim_43-0" class="reference"><a href="#cite_note-Bechtolsheim-43">[42]</a></sup> Google received money from three other <a href="/wiki/Angel_investor" title="Angel investor">angel investors</a> in 1998: <a href="/wiki/Amazon.com" class="mw-redirect" title="Amazon.com">Amazon.com</a> founder <a href="/wiki/Jeff_Bezos" title="Jeff Bezos">Jeff Bezos</a>, Stanford University computer science professor <a href="/wiki/David_Cheriton" title="David Cheriton">David Cheriton</a>, and entrepreneur <a href="/wiki/Ram_Shriram" title="Ram Shriram">Ram Shriram</a>.<sup id="cite_ref-endofworld_44-0" class="reference"><a href="#cite_note-endofworld-44">[43]</a></sup> Between these initial investors, friends, and family Google raised around 1 million dollars, which is what allowed them to open up their original shop in <a href="/wiki/Menlo_Park,_California" title="Menlo Park, California">Menlo Park, California</a>.<sup id="cite_ref-45" class="reference"><a href="#cite_note-45">[44]</a></sup></p>
   <p>After some additional, small investments through the end of 1998 to early 1999,<sup id="cite_ref-endofworld_44-1" class="reference"><a href="#cite_note-endofworld-44">[43]</a></sup> a new $25 million round of funding was announced on June 7, 1999,<sup id="cite_ref-46" class="reference"><a href="#cite_note-46">[45]</a></sup> with major investors including the <a href="/wiki/Venture_capital" title="Venture capital">venture capital</a> firms <a href="/wiki/Kleiner_Perkins" title="Kleiner Perkins">Kleiner Perkins</a> and <a href="/wiki/Sequoia_Capital" title="Sequoia Capital">Sequoia Capital</a>.<sup id="cite_ref-Bechtolsheim_43-1" class="reference"><a href="#cite_note-Bechtolsheim-43">[42]</a></sup></p>
   <h3><span class="mw-headline" id="Growth">Growth</span></h3>
   <p>In March 1999, the company moved its offices to <a href="/wiki/Palo_Alto,_California" title="Palo Alto, California">Palo Alto, California</a>,<sup id="cite_ref-47" class="reference"><a href="#cite_note-47">[46]</a></sup> which is home to several prominent <a href="/wiki/Silicon_Valley" title="Silicon Valley">Silicon Valley</a> technology start-ups.<sup id="cite_ref-48" class="reference"><a href="#cite_note-48">[47]</a></sup> The next year, Google began selling advertisements associated with search keywords against Page and Brin's initial opposition toward an advertising-funded search engine.<sup id="cite_ref-49" class="reference"><a href="#cite_note-49">[48]</a></sup><sup id="cite_ref-milestones_20-3" class="reference"><a href="#cite_note-milestones-20">[19]</a></sup> To maintain an uncluttered page design, advertisements were solely text-based.<sup id="cite_ref-50" class="reference"><a href="#cite_note-50">[49]</a></sup> In June 2000, it was announced that Google would become the default search engine provider for <a href="/wiki/Yahoo!" title="Yahoo!">Yahoo!</a>, one of the most popular websites at the time, replacing <a href="/wiki/Inktomi" title="Inktomi">Inktomi</a>.<sup id="cite_ref-51" class="reference"><a href="#cite_note-51">[50]</a></sup><sup id="cite_ref-52" class="reference"><a href="#cite_note-52">[51]</a></sup></p>
   <div class="thumb tright">
      <div class="thumbinner" style="width:172px;">
         <a href="/wiki/File:Google%E2%80%99s_First_Production_Server.jpg" class="image"><img alt="Google's first servers, showing lots of exposed wiring and circuit boards" src="//upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Google%E2%80%99s_First_Production_Server.jpg/170px-Google%E2%80%99s_First_Production_Server.jpg" decoding="async" width="170" height="281" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Google%E2%80%99s_First_Production_Server.jpg/255px-Google%E2%80%99s_First_Production_Server.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Google%E2%80%99s_First_Production_Server.jpg/340px-Google%E2%80%99s_First_Production_Server.jpg 2x" data-file-width="2543" data-file-height="4209"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Google%E2%80%99s_First_Production_Server.jpg" class="internal" title="Enlarge"></a></div>
            Google's first production server.<sup id="cite_ref-53" class="reference"><a href="#cite_note-53">[52]</a></sup>
         </div>
      </div>
   </div>
   <p>In 2003, after outgrowing two other locations, the company leased an office complex from <a href="/wiki/Silicon_Graphics" title="Silicon Graphics">Silicon Graphics</a>, at 1600 Amphitheatre Parkway in <a href="/wiki/Mountain_View,_California" title="Mountain View, California">Mountain View, California</a>.<sup id="cite_ref-sgibldg_54-0" class="reference"><a href="#cite_note-sgibldg-54">[53]</a></sup> The complex became known as the <a href="/wiki/Googleplex" title="Googleplex">Googleplex</a>, a play on the word <a href="/wiki/Googolplex" title="Googolplex">googolplex</a>, the number one followed by a googol zeroes. Three years later, Google bought the property from SGI for $319&nbsp;million.<sup id="cite_ref-googleplexpurchase_55-0" class="reference"><a href="#cite_note-googleplexpurchase-55">[54]</a></sup> By that time, the name "Google" had found its way into everyday language, causing the verb "<a href="/wiki/Google_(verb)" title="Google (verb)">google</a>" to be added to the <i><a href="/wiki/Merriam-Webster_Collegiate_Dictionary" class="mw-redirect" title="Merriam-Webster Collegiate Dictionary">Merriam-Webster Collegiate Dictionary</a></i> and the <i><a href="/wiki/Oxford_English_Dictionary" title="Oxford English Dictionary">Oxford English Dictionary</a></i>, denoted as: "to use the Google search engine to obtain information on the Internet".<sup id="cite_ref-56" class="reference"><a href="#cite_note-56">[55]</a></sup><sup id="cite_ref-57" class="reference"><a href="#cite_note-57">[56]</a></sup> Additionally, in 2001 Google's Investors felt the need to have a strong internal management, and they agreed to hire <a href="/wiki/Eric_Schmidt" title="Eric Schmidt">Eric Schmidt</a> as the Chairman and CEO of Google <sup id="cite_ref-Google_Inc_58-0" class="reference"><a href="#cite_note-Google_Inc-58">[57]</a></sup></p>
   <h3><span class="mw-headline" id="Initial_public_offering">Initial public offering</span></h3>
   <p>On August 19, 2004, Google became a <a href="/wiki/Public_company" title="Public company">public company</a> via an <a href="/wiki/Initial_public_offering" title="Initial public offering">initial public offering</a>. At that time Larry Page, Sergey Brin, and Eric Schmidt agreed to work together at Google for 20 years, until the year 2024.<sup id="cite_ref-59" class="reference"><a href="#cite_note-59">[58]</a></sup> The company offered 19,605,052 shares at a price of $85 per share.<sup id="cite_ref-IPO_60-0" class="reference"><a href="#cite_note-IPO-60">[59]</a></sup><sup id="cite_ref-:1_61-0" class="reference"><a href="#cite_note-:1-61">[60]</a></sup> Shares were sold in an online auction format using a system built by <a href="/wiki/Morgan_Stanley" title="Morgan Stanley">Morgan Stanley</a> and <a href="/wiki/Credit_Suisse" title="Credit Suisse">Credit Suisse</a>, underwriters for the deal.<sup id="cite_ref-62" class="reference"><a href="#cite_note-62">[61]</a></sup><sup id="cite_ref-63" class="reference"><a href="#cite_note-63">[62]</a></sup> The sale of $1.67 billion gave Google a <a href="/wiki/Market_capitalization" title="Market capitalization">market capitalization</a> of more than $23 billion.<sup id="cite_ref-washpost_64-0" class="reference"><a href="#cite_note-washpost-64">[63]</a></sup></p>
   <div class="thumb tleft">
      <div class="thumbinner" style="width:172px;">
         <a href="/wiki/File:Eric_Schmidt_at_the_37th_G8_Summit_in_Deauville_037.jpg" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Eric_Schmidt_at_the_37th_G8_Summit_in_Deauville_037.jpg/170px-Eric_Schmidt_at_the_37th_G8_Summit_in_Deauville_037.jpg" decoding="async" width="170" height="228" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Eric_Schmidt_at_the_37th_G8_Summit_in_Deauville_037.jpg/255px-Eric_Schmidt_at_the_37th_G8_Summit_in_Deauville_037.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Eric_Schmidt_at_the_37th_G8_Summit_in_Deauville_037.jpg/340px-Eric_Schmidt_at_the_37th_G8_Summit_in_Deauville_037.jpg 2x" data-file-width="2645" data-file-height="3541"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Eric_Schmidt_at_the_37th_G8_Summit_in_Deauville_037.jpg" class="internal" title="Enlarge"></a></div>
            <a href="/wiki/Eric_Schmidt" title="Eric Schmidt">Eric Schmidt</a>, CEO of Google from 2001 to 2011
         </div>
      </div>
   </div>
   <p>On November 13, 2006, Google acquired <a href="/wiki/YouTube" title="YouTube">YouTube</a> for $1.65 billion in Google stock,<sup id="cite_ref-65" class="reference"><a href="#cite_note-65">[64]</a></sup><sup id="cite_ref-66" class="reference"><a href="#cite_note-66">[65]</a></sup><sup id="cite_ref-67" class="reference"><a href="#cite_note-67">[66]</a></sup><sup id="cite_ref-68" class="reference"><a href="#cite_note-68">[67]</a></sup> On March 11, 2008, Google acquired <a href="/wiki/DoubleClick" title="DoubleClick">DoubleClick</a> for $3.1&nbsp;billion, transferring to Google valuable relationships that DoubleClick had with Web publishers and advertising agencies.<sup id="cite_ref-69" class="reference"><a href="#cite_note-69">[68]</a></sup><sup id="cite_ref-70" class="reference"><a href="#cite_note-70">[69]</a></sup></p>
   <p>In May 2011, the number of monthly unique visitors to Google surpassed one billion for the first time.<sup id="cite_ref-71" class="reference"><a href="#cite_note-71">[70]</a></sup><sup id="cite_ref-72" class="reference"><a href="#cite_note-72">[71]</a></sup></p>
   <p>By 2011, Google was handling approximately 3 billion searches per day. To handle this workload, Google built 11 <a href="/wiki/Data_centers" class="mw-redirect" title="Data centers">data centers</a> around the world with some several thousand servers in each. These data centers allowed Google to handle the ever changing workload more efficiently.<sup id="cite_ref-Google_Inc_58-1" class="reference"><a href="#cite_note-Google_Inc-58">[57]</a></sup></p>
   <p>In May 2012, Google acquired <a href="/wiki/Motorola_Mobility" title="Motorola Mobility">Motorola Mobility</a> for $12.5&nbsp;billion, in its largest acquisition to date.<sup id="cite_ref-73" class="reference"><a href="#cite_note-73">[72]</a></sup><sup id="cite_ref-74" class="reference"><a href="#cite_note-74">[73]</a></sup><sup id="cite_ref-75" class="reference"><a href="#cite_note-75">[74]</a></sup> This purchase was made in part to help Google gain Motorola's considerable patent portfolio on mobile phones and wireless technologies, to help protect Google in its ongoing patent disputes with other companies,<sup id="cite_ref-76" class="reference"><a href="#cite_note-76">[75]</a></sup> mainly <a href="/wiki/Apple_Inc." title="Apple Inc.">Apple</a> and <a href="/wiki/Microsoft" title="Microsoft">Microsoft</a>,<sup id="cite_ref-77" class="reference"><a href="#cite_note-77">[76]</a></sup> and to allow it to continue to freely offer <a href="/wiki/Android_(operating_system)" title="Android (operating system)">Android</a>.<sup id="cite_ref-cnet_78-0" class="reference"><a href="#cite_note-cnet-78">[77]</a></sup></p>
   <h3><span class="mw-headline" id="2012_onward">2012 onward</span></h3>
   <p>In June 2013, Google acquired <a href="/wiki/Waze" title="Waze">Waze</a>, a $966 million deal.<sup id="cite_ref-79" class="reference"><a href="#cite_note-79">[78]</a></sup> While Waze would remain an independent entity, its social features, such as its crowdsourced location platform, were reportedly valuable integrations between Waze and <a href="/wiki/Google_Maps" title="Google Maps">Google Maps</a>, Google's own mapping service.<sup id="cite_ref-80" class="reference"><a href="#cite_note-80">[79]</a></sup></p>
   <p>Google announced the launch of a new company, called <a href="/wiki/Calico_(company)" title="Calico (company)">Calico</a>, on September 19, 2013, to be led by <a href="/wiki/Apple_Inc." title="Apple Inc.">Apple Inc.</a> chairman <a href="/wiki/Arthur_D._Levinson" title="Arthur D. Levinson">Arthur Levinson</a>. In the official public statement, Page explained that the "health and well-being" company would focus on "the challenge of ageing and associated diseases".<sup id="cite_ref-81" class="reference"><a href="#cite_note-81">[80]</a></sup></p>
   <div class="thumb tright">
      <div class="thumbinner" style="width:172px;">
         <a href="/wiki/File:Google-Deep_Mind_headquarters_in_London,_6_Pancras_Square.jpg" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/4/45/Google-Deep_Mind_headquarters_in_London%2C_6_Pancras_Square.jpg/170px-Google-Deep_Mind_headquarters_in_London%2C_6_Pancras_Square.jpg" decoding="async" width="170" height="227" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/4/45/Google-Deep_Mind_headquarters_in_London%2C_6_Pancras_Square.jpg/255px-Google-Deep_Mind_headquarters_in_London%2C_6_Pancras_Square.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/4/45/Google-Deep_Mind_headquarters_in_London%2C_6_Pancras_Square.jpg/340px-Google-Deep_Mind_headquarters_in_London%2C_6_Pancras_Square.jpg 2x" data-file-width="2448" data-file-height="3264"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Google-Deep_Mind_headquarters_in_London,_6_Pancras_Square.jpg" class="internal" title="Enlarge"></a></div>
            Entrance of building where Google and its subsidiary Deep Mind are located at 6 Pancras Square, London
         </div>
      </div>
   </div>
   <p>On January 26, 2014, Google announced it had agreed to acquire <a href="/wiki/DeepMind_Technologies" class="mw-redirect" title="DeepMind Technologies">DeepMind Technologies</a>, a privately held artificial intelligence company from <a href="/wiki/London" title="London">London</a>.<sup id="cite_ref-82" class="reference"><a href="#cite_note-82">[81]</a></sup> Technology news website <i><a href="/wiki/Recode" title="Recode">Recode</a></i> reported that the company was purchased for $400 million though it was not disclosed where the information came from. A Google spokesman would not comment of the price.<sup id="cite_ref-Helgren-_DeepMind_83-0" class="reference"><a href="#cite_note-Helgren-_DeepMind-83">[82]</a></sup><sup id="cite_ref-Ribeiro-_DeepMind_84-0" class="reference"><a href="#cite_note-Ribeiro-_DeepMind-84">[83]</a></sup> The purchase of DeepMind aids in Google's recent growth in the artificial intelligence and robotics community.<sup id="cite_ref-85" class="reference"><a href="#cite_note-85">[84]</a></sup></p>
   <p>According to Interbrand's annual Best Global Brands report, Google has been the second most valuable brand in the world (behind <a href="/wiki/Apple_Inc." title="Apple Inc.">Apple Inc.</a>) in 2013,<sup id="cite_ref-86" class="reference"><a href="#cite_note-86">[85]</a></sup> 2014,<sup id="cite_ref-87" class="reference"><a href="#cite_note-87">[86]</a></sup> 2015,<sup id="cite_ref-88" class="reference"><a href="#cite_note-88">[87]</a></sup> and 2016, with a valuation of $133 billion.<sup id="cite_ref-89" class="reference"><a href="#cite_note-89">[88]</a></sup></p>
   <p>On August 10, 2015, Google announced plans to reorganize its various interests as a <a href="/wiki/Conglomerate_(company)" title="Conglomerate (company)">conglomerate</a> called <a href="/wiki/Alphabet_Inc." title="Alphabet Inc.">Alphabet Inc.</a> Google became Alphabet's largest subsidiary and the umbrella company for Alphabet's Internet interests. Upon completion of the restructure, <a href="/wiki/Sundar_Pichai" title="Sundar Pichai">Sundar Pichai</a> became CEO of Google, replacing <a href="/wiki/Larry_Page" title="Larry Page">Larry Page</a>, who became CEO of Alphabet.<sup id="cite_ref-90" class="reference"><a href="#cite_note-90">[89]</a></sup><sup id="cite_ref-91" class="reference"><a href="#cite_note-91">[90]</a></sup><sup id="cite_ref-92" class="reference"><a href="#cite_note-92">[91]</a></sup></p>
   <div class="thumb tright">
      <div class="thumbinner" style="width:222px;">
         <a href="/wiki/File:The_CEO_of_Google,_Mr._Sundar_Pichai_calls_on_the_Prime_Minister,_Shri_Narendra_Modi,_in_New_Delhi_on_December_17,_2015_(1).jpg" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/5/5b/The_CEO_of_Google%2C_Mr._Sundar_Pichai_calls_on_the_Prime_Minister%2C_Shri_Narendra_Modi%2C_in_New_Delhi_on_December_17%2C_2015_%281%29.jpg/220px-The_CEO_of_Google%2C_Mr._Sundar_Pichai_calls_on_the_Prime_Minister%2C_Shri_Narendra_Modi%2C_in_New_Delhi_on_December_17%2C_2015_%281%29.jpg" decoding="async" width="220" height="152" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/5/5b/The_CEO_of_Google%2C_Mr._Sundar_Pichai_calls_on_the_Prime_Minister%2C_Shri_Narendra_Modi%2C_in_New_Delhi_on_December_17%2C_2015_%281%29.jpg/330px-The_CEO_of_Google%2C_Mr._Sundar_Pichai_calls_on_the_Prime_Minister%2C_Shri_Narendra_Modi%2C_in_New_Delhi_on_December_17%2C_2015_%281%29.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/5/5b/The_CEO_of_Google%2C_Mr._Sundar_Pichai_calls_on_the_Prime_Minister%2C_Shri_Narendra_Modi%2C_in_New_Delhi_on_December_17%2C_2015_%281%29.jpg/440px-The_CEO_of_Google%2C_Mr._Sundar_Pichai_calls_on_the_Prime_Minister%2C_Shri_Narendra_Modi%2C_in_New_Delhi_on_December_17%2C_2015_%281%29.jpg 2x" data-file-width="2200" data-file-height="1524"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:The_CEO_of_Google,_Mr._Sundar_Pichai_calls_on_the_Prime_Minister,_Shri_Narendra_Modi,_in_New_Delhi_on_December_17,_2015_(1).jpg" class="internal" title="Enlarge"></a></div>
            Current Google CEO, <a href="/wiki/Sundar_Pichai" title="Sundar Pichai">Sundar Pichai</a>, with Prime Minister of India, <a href="/wiki/Narendra_Modi" title="Narendra Modi">Narendra Modi</a>
         </div>
      </div>
   </div>
   <p>On August 8, 2017, Google fired employee <a href="/wiki/James_Damore" class="mw-redirect" title="James Damore">James Damore</a> after he distributed a memo throughout the company which argued that bias and "<a href="/wiki/Google%27s_Ideological_Echo_Chamber" title="Google's Ideological Echo Chamber">Google's Ideological Echo Chamber</a>" clouded their thinking about diversity and inclusion, and that it is also biological factors, not discrimination alone, that cause the average woman to be less interested than men in technical positions.<sup id="cite_ref-93" class="reference"><a href="#cite_note-93">[92]</a></sup> Google CEO Sundar Pichai accused Damore in violating company policy by "advancing harmful gender stereotypes in our workplace", and he was fired on the same day.<sup id="cite_ref-94" class="reference"><a href="#cite_note-94">[93]</a></sup><sup id="cite_ref-95" class="reference"><a href="#cite_note-95">[94]</a></sup><sup id="cite_ref-96" class="reference"><a href="#cite_note-96">[95]</a></sup> <i>New York Times</i> columnist <a href="/wiki/David_Brooks_(political_commentator)" class="mw-redirect" title="David Brooks (political commentator)">David Brooks</a> argued Pichai had mishandled the case, and called for his resignation.<sup id="cite_ref-BrooksNYT_97-0" class="reference"><a href="#cite_note-BrooksNYT-97">[96]</a></sup><sup id="cite_ref-98" class="reference"><a href="#cite_note-98">[97]</a></sup></p>
   <p>Between 2018 and 2019, <a href="/wiki/Google_worker_organization" title="Google worker organization">tensions between the company's leadership and its workers escalated</a> as staff protested company decisions on internal sexual harassment, <a href="/wiki/Dragonfly_(search_engine)" title="Dragonfly (search engine)">Dragonfly</a>, a censored Chinese search engine, and <a href="/wiki/Project_Maven" class="mw-redirect" title="Project Maven">Project Maven</a>, a military drone artificial intelligence, which had been seen as areas of revenue growth for the company.<sup id="cite_ref-99" class="reference"><a href="#cite_note-99">[98]</a></sup><sup id="cite_ref-Verge_busting_100-0" class="reference"><a href="#cite_note-Verge_busting-100">[99]</a></sup> On October 25, 2018, <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i> published the <i>exposé</i>, "How Google Protected <a href="/wiki/Andy_Rubin" title="Andy Rubin">Andy Rubin</a>, the ‘Father of Android’". The company subsequently announced that "48 employees have been fired over the last two years" for sexual misconduct.<sup id="cite_ref-101" class="reference"><a href="#cite_note-101">[100]</a></sup> On November 1, 2018, more than 20,000 Google employees and contractors staged a global walk-out to protest the company's handling of sexual harassment complaints.<sup id="cite_ref-102" class="reference"><a href="#cite_note-102">[101]</a></sup><sup id="cite_ref-103" class="reference"><a href="#cite_note-103">[102]</a></sup> Later in 2019, some workers accused the company of retaliating against internal activists.<sup id="cite_ref-Verge_busting_100-1" class="reference"><a href="#cite_note-Verge_busting-100">[99]</a></sup></p>
   <p>On March 19, 2019, Google announced that it would enter the video game market, launching a <a href="/wiki/Cloud_gaming" title="Cloud gaming">cloud gaming</a> platform called <a href="/wiki/Google_Stadia" title="Google Stadia">Google Stadia</a>.<sup id="cite_ref-unveils_104-0" class="reference"><a href="#cite_note-unveils-104">[103]</a></sup></p>
   <p>On June 3, 2019, the <a href="/wiki/United_States_Department_of_Justice" title="United States Department of Justice">United States Department of Justice</a> reported that it would investigate Google for <a href="/wiki/Antitrust" class="mw-redirect" title="Antitrust">antitrust</a> violations.<sup id="cite_ref-105" class="reference"><a href="#cite_note-105">[104]</a></sup> This led to the filing of an antitrust lawsuit in October 2020, on the grounds the company had abused a monopoly position in the <a href="/wiki/Web_search_engine" class="mw-redirect" title="Web search engine">search</a> and <a href="/wiki/Search_advertising" title="Search advertising">search advertising</a> markets.<sup id="cite_ref-106" class="reference"><a href="#cite_note-106">[105]</a></sup></p>
   <p>In December 2019, former <a href="/wiki/PayPal" title="PayPal">PayPal</a> <a href="/wiki/Chief_operating_officer" title="Chief operating officer">chief operating officer</a> Bill Ready became Google's new commerce chief. Ready's role will not be directly involved with <a href="/wiki/Google_Pay" title="Google Pay">Google Pay</a>.<sup id="cite_ref-107" class="reference"><a href="#cite_note-107">[106]</a></sup></p>
   <p>In April 2020, due to the <a href="/wiki/COVID-19_pandemic" title="COVID-19 pandemic">COVID-19 pandemic</a>, Google announced several cost-cutting measures. Such measures included slowing down hiring for the remainder of 2020, except for a small number of strategic areas, recalibrating the focus and pace of investments in areas like data centers and machines, and non-business essential marketing and travel.<sup id="cite_ref-108" class="reference"><a href="#cite_note-108">[107]</a></sup></p>
   <p>The <a href="/wiki/2020_Google_services_outages" title="2020 Google services outages">2020 Google services outages</a> disrupted Google services: one in August that affected Google Drive among others, another in November affecting YouTube, and a third in December affecting the entire suite of Google applications. All three outages were resolved within hours.<sup id="cite_ref-109" class="reference"><a href="#cite_note-109">[108]</a></sup><sup id="cite_ref-110" class="reference"><a href="#cite_note-110">[109]</a></sup><sup id="cite_ref-111" class="reference"><a href="#cite_note-111">[110]</a></sup></p>
   <p>In January 2021, the <a href="/wiki/Australian_Government" title="Australian Government">Australian Government</a> proposed legislation that would require Google and Facebook to pay media companies for the right to use their content. In response, Google threatened to close off access to its search engine in Australia.<sup id="cite_ref-112" class="reference"><a href="#cite_note-112">[111]</a></sup></p>
   <p>In March 2021, Google reportedly paid $20 million for <a href="/wiki/Ubisoft" title="Ubisoft">Ubisoft</a> ports on <a href="/wiki/Google_Stadia" title="Google Stadia">Google Stadia</a>.<sup id="cite_ref-113" class="reference"><a href="#cite_note-113">[112]</a></sup> Google spent "tens of millions of dollars" on getting major publishers such as <a href="/wiki/Ubisoft" title="Ubisoft">Ubisoft</a> and Take-Two to bring some of their biggest games to Stadia.</p>
   <p>In April 2021, The Wall Street Journal reported that Google ran a years-long program called 'Project Bernanke' that used data from past advertising bids to gain an advantage over competing ad services. This was revealed in documents concerning the antitrust lawsuit filed by ten US states against Google in December.<sup id="cite_ref-114" class="reference"><a href="#cite_note-114">[113]</a></sup></p>
   <h2><span class="mw-headline" id="Products_and_services">Products and services</span></h2>
   <div role="note" class="hatnote navigation-not-searchable">Main article: <a href="/wiki/List_of_Google_products" title="List of Google products">List of Google products</a></div>
   <h3><span class="mw-headline" id="Search_engine">Search engine</span></h3>
   <div role="note" class="hatnote navigation-not-searchable">Main articles: <a href="/wiki/Google_Search" title="Google Search">Google Search</a> and <a href="/wiki/Google_Images" title="Google Images">Google Images</a></div>
   <p>Google <a href="/wiki/Search_engine_indexing" title="Search engine indexing">indexes</a> billions of web pages to allow users to search for the information they desire through the use of keywords and <a href="/wiki/Operator_(computer_programming)" title="Operator (computer programming)">operators</a>.<sup id="cite_ref-115" class="reference"><a href="#cite_note-115">[114]</a></sup> According to <a href="/wiki/ComScore" class="mw-redirect" title="ComScore">comScore</a> market research from November 2009, <a href="/wiki/Google_Search" title="Google Search">Google Search</a> is the dominant search engine in the United States market, with a <a href="/wiki/Market_share" title="Market share">market share</a> of 65.6%.<sup id="cite_ref-comscore_116-0" class="reference"><a href="#cite_note-comscore-116">[115]</a></sup> In May 2017, Google enabled a new "Personal" tab in Google Search, letting users search for content in their Google accounts' various services, including email messages from <a href="/wiki/Gmail" title="Gmail">Gmail</a> and photos from <a href="/wiki/Google_Photos" title="Google Photos">Google Photos</a>.<sup id="cite_ref-117" class="reference"><a href="#cite_note-117">[116]</a></sup><sup id="cite_ref-118" class="reference"><a href="#cite_note-118">[117]</a></sup></p>
   <p>Google launched its <a href="/wiki/Google_News" title="Google News">Google News</a> service in 2002, an automated service which summarizes news articles from various websites.<sup id="cite_ref-119" class="reference"><a href="#cite_note-119">[118]</a></sup> Google also hosts <a href="/wiki/Google_Books" title="Google Books">Google Books</a>, a service which searches the text found in books in its database and shows limited previews or and the full book where allowed.<sup id="cite_ref-120" class="reference"><a href="#cite_note-120">[119]</a></sup></p>
   <h3><span class="mw-headline" id="Advertising">Advertising</span></h3>
   <div class="thumb tright">
      <div class="thumbinner" style="width:222px;">
         <a href="/wiki/File:Ad-tech_London_2010_(2).JPG" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Ad-tech_London_2010_%282%29.JPG/220px-Ad-tech_London_2010_%282%29.JPG" decoding="async" width="220" height="165" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Ad-tech_London_2010_%282%29.JPG/330px-Ad-tech_London_2010_%282%29.JPG 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Ad-tech_London_2010_%282%29.JPG/440px-Ad-tech_London_2010_%282%29.JPG 2x" data-file-width="3264" data-file-height="2448"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Ad-tech_London_2010_(2).JPG" class="internal" title="Enlarge"></a></div>
            Google on ad-tech London, 2010
         </div>
      </div>
   </div>
   <p>Google generates most of its revenues from advertising. This includes sales of apps, purchases made in-app, digital content products on Google and YouTube, Android and licensing and service fees, including fees received for Google Cloud offerings. Forty-six percent of this profit was from clicks (cost per clicks), amounting to US$109,652 million in 2017. This includes three principal methods, namely <a href="/wiki/AdMob" title="AdMob">AdMob</a>, <a href="/wiki/AdSense" class="mw-redirect" title="AdSense">AdSense</a> (such as AdSense for Content, <a href="/wiki/AdSense" class="mw-redirect" title="AdSense">AdSense</a> for Search, etc.) and DoubleClick AdExchange.<sup id="cite_ref-agm2017_121-0" class="reference"><a href="#cite_note-agm2017-121">[120]</a></sup></p>
   <p>In addition to its own algorithms for understanding search requests, Google uses technology its acquisition of <a href="/wiki/DoubleClick" title="DoubleClick">DoubleClick</a>, to project user interest and target advertising to the search context and the user history.<sup id="cite_ref-122" class="reference"><a href="#cite_note-122">[121]</a></sup><sup id="cite_ref-123" class="reference"><a href="#cite_note-123">[122]</a></sup></p>
   <p>In 2007, Google launched "<a href="/wiki/AdSense_for_Mobile" class="mw-redirect" title="AdSense for Mobile">AdSense for Mobile</a>", taking advantage of the emerging mobile advertising market.<sup id="cite_ref-adsense_mobile_124-0" class="reference"><a href="#cite_note-adsense_mobile-124">[123]</a></sup></p>
   <p><a href="/wiki/Google_Analytics" title="Google Analytics">Google Analytics</a> allows website owners to track where and how people use their website, for example by examining click rates for all the links on a page.<sup id="cite_ref-125" class="reference"><a href="#cite_note-125">[124]</a></sup> Google advertisements can be placed on third-party websites in a two-part program. <a href="/wiki/Google_Ads" title="Google Ads">Google Ads</a> allows advertisers to display their advertisements in the Google content network, through a cost-per-click scheme.<sup id="cite_ref-126" class="reference"><a href="#cite_note-126">[125]</a></sup> The sister service, Google <a href="/wiki/AdSense" class="mw-redirect" title="AdSense">AdSense</a>, allows website owners to display these advertisements on their website and earn money every time ads are clicked.<sup id="cite_ref-127" class="reference"><a href="#cite_note-127">[126]</a></sup> One of the criticisms of this program is the possibility of <a href="/wiki/Click_fraud" title="Click fraud">click fraud</a>, which occurs when a person or automated script clicks on advertisements without being interested in the product, causing the advertiser to pay money to Google unduly. Industry reports in 2006 claimed that approximately 14 to 20&nbsp;percent of clicks were fraudulent or invalid.<sup id="cite_ref-128" class="reference"><a href="#cite_note-128">[127]</a></sup> <a href="/wiki/Google_Search_Console" title="Google Search Console">Google Search Console</a> (rebranded from Google Webmaster Tools in May 2015) allows <a href="/wiki/Webmasters" class="mw-redirect" title="Webmasters">webmasters</a> to check the sitemap, crawl rate, and for security issues of their websites, as well as optimize their website's visibility.</p>
   <h3><span class="mw-headline" id="Consumer_services">Consumer services</span></h3>
   <h4><span class="mw-headline" id="Web-based_services">Web-based services</span></h4>
   <p>Google offers <a href="/wiki/Gmail" title="Gmail">Gmail</a> for <a href="/wiki/Email" title="Email">email</a>,<sup id="cite_ref-129" class="reference"><a href="#cite_note-129">[128]</a></sup> <a href="/wiki/Google_Calendar" title="Google Calendar">Google Calendar</a> for time-management and scheduling,<sup id="cite_ref-130" class="reference"><a href="#cite_note-130">[129]</a></sup> <a href="/wiki/Google_Maps" title="Google Maps">Google Maps</a> for mapping, navigation and <a href="/wiki/Satellite_imagery" title="Satellite imagery">satellite imagery</a>,<sup id="cite_ref-131" class="reference"><a href="#cite_note-131">[130]</a></sup> <a href="/wiki/Google_Drive" title="Google Drive">Google Drive</a> for <a href="/wiki/File_hosting_service" title="File hosting service">cloud storage</a> of files,<sup id="cite_ref-verge-drive-announced_132-0" class="reference"><a href="#cite_note-verge-drive-announced-132">[131]</a></sup> <a href="/wiki/Google_Docs" title="Google Docs">Google Docs</a>, <a href="/wiki/Google_Sheets" title="Google Sheets">Sheets</a> and <a href="/wiki/Google_Slides" title="Google Slides">Slides</a> for productivity,<sup id="cite_ref-verge-drive-announced_132-1" class="reference"><a href="#cite_note-verge-drive-announced-132">[131]</a></sup> <a href="/wiki/Google_Photos" title="Google Photos">Google Photos</a> for photo storage and sharing,<sup id="cite_ref-133" class="reference"><a href="#cite_note-133">[132]</a></sup> <a href="/wiki/Google_Keep" title="Google Keep">Google Keep</a> for <a href="/wiki/Note-taking" title="Note-taking">note-taking</a>,<sup id="cite_ref-134" class="reference"><a href="#cite_note-134">[133]</a></sup> <a href="/wiki/Google_Translate" title="Google Translate">Google Translate</a> for language translation,<sup id="cite_ref-135" class="reference"><a href="#cite_note-135">[134]</a></sup> <a href="/wiki/YouTube" title="YouTube">YouTube</a> for video viewing and sharing,<sup id="cite_ref-136" class="reference"><a href="#cite_note-136">[135]</a></sup> <a href="/wiki/Google_My_Business" class="mw-redirect" title="Google My Business">Google My Business</a> for managing public business information,<sup id="cite_ref-137" class="reference"><a href="#cite_note-137">[136]</a></sup> and <a href="/wiki/Google_Duo" title="Google Duo">Duo</a> for social interaction.<sup id="cite_ref-138" class="reference"><a href="#cite_note-138">[137]</a></sup> In March 2019, Google unveiled a <a href="/wiki/Cloud_gaming" title="Cloud gaming">cloud gaming</a> service named <a href="/wiki/Google_Stadia" title="Google Stadia">Stadia</a>.<sup id="cite_ref-unveils_104-1" class="reference"><a href="#cite_note-unveils-104">[103]</a></sup></p>
   <p>Some Google services are not web-based. <a href="/wiki/Google_Earth" title="Google Earth">Google Earth</a>, launched in 2005, allowed users to see high-definition satellite pictures from all over the world for free through a client software downloaded to their computers.<sup id="cite_ref-139" class="reference"><a href="#cite_note-139">[138]</a></sup></p>
   <h4><span class="mw-headline" id="Software">Software</span></h4>
   <p>Google develops the <a href="/wiki/Android_(operating_system)" title="Android (operating system)">Android</a> <a href="/wiki/Mobile_operating_system" title="Mobile operating system">mobile operating system</a>,<sup id="cite_ref-140" class="reference"><a href="#cite_note-140">[139]</a></sup> as well as its <a href="/wiki/Android_Wear" class="mw-redirect" title="Android Wear">smartwatch</a>,<sup id="cite_ref-141" class="reference"><a href="#cite_note-141">[140]</a></sup> <a href="/wiki/Android_TV" title="Android TV">television</a>,<sup id="cite_ref-142" class="reference"><a href="#cite_note-142">[141]</a></sup> <a href="/wiki/Android_Auto" title="Android Auto">car</a>,<sup id="cite_ref-143" class="reference"><a href="#cite_note-143">[142]</a></sup> and <a href="/wiki/Internet_of_things" title="Internet of things">Internet of things</a>-enabled <a href="/wiki/Android_Things" title="Android Things">smart devices</a> variations.<sup id="cite_ref-144" class="reference"><a href="#cite_note-144">[143]</a></sup></p>
   <p>It also develops the <a href="/wiki/Google_Chrome" title="Google Chrome">Google Chrome</a> web browser,<sup id="cite_ref-145" class="reference"><a href="#cite_note-145">[144]</a></sup> and <a href="/wiki/Chrome_OS" title="Chrome OS">Chrome OS</a>, an operating system based on Chrome.<sup id="cite_ref-146" class="reference"><a href="#cite_note-146">[145]</a></sup></p>
   <h4><span class="mw-headline" id="Hardware">Hardware</span></h4>
   <div class="thumb tright">
      <div class="thumbinner" style="width:222px;">
         <a href="/wiki/File:Pixel_3_%E3%81%A8_Pixel_3_XL_%E3%82%92%E5%88%9D%E8%A7%A6%E3%80%82%E6%9C%AC%E4%BD%93%E3%82%92%E3%82%AE%E3%83%A5%E3%83%83%E3%81%A8%E6%8F%A1%E3%82%8B%E3%81%A8_Google_Assistant_%E3%81%8C%E7%AB%8B%E3%81%A1%E4%B8%8A%E3%81%8C%E3%82%8B%E3%81%AE%E3%81%8C%E3%81%8A%E3%82%82%E3%81%97%E3%82%8D%E3%81%84%E3%80%82_%E3%83%AF%E3%82%B7%E3%83%B3%E3%83%88%E3%83%B3DC_(44519013945).jpg" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Pixel_3_%E3%81%A8_Pixel_3_XL_%E3%82%92%E5%88%9D%E8%A7%A6%E3%80%82%E6%9C%AC%E4%BD%93%E3%82%92%E3%82%AE%E3%83%A5%E3%83%83%E3%81%A8%E6%8F%A1%E3%82%8B%E3%81%A8_Google_Assistant_%E3%81%8C%E7%AB%8B%E3%81%A1%E4%B8%8A%E3%81%8C%E3%82%8B%E3%81%AE%E3%81%8C%E3%81%8A%E3%82%82%E3%81%97%E3%82%8D%E3%81%84%E3%80%82_%E3%83%AF%E3%82%B7%E3%83%B3%E3%83%88%E3%83%B3DC_%2844519013945%29.jpg/220px-thumbnail.jpg" decoding="async" width="220" height="233" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Pixel_3_%E3%81%A8_Pixel_3_XL_%E3%82%92%E5%88%9D%E8%A7%A6%E3%80%82%E6%9C%AC%E4%BD%93%E3%82%92%E3%82%AE%E3%83%A5%E3%83%83%E3%81%A8%E6%8F%A1%E3%82%8B%E3%81%A8_Google_Assistant_%E3%81%8C%E7%AB%8B%E3%81%A1%E4%B8%8A%E3%81%8C%E3%82%8B%E3%81%AE%E3%81%8C%E3%81%8A%E3%82%82%E3%81%97%E3%82%8D%E3%81%84%E3%80%82_%E3%83%AF%E3%82%B7%E3%83%B3%E3%83%88%E3%83%B3DC_%2844519013945%29.jpg/330px-thumbnail.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Pixel_3_%E3%81%A8_Pixel_3_XL_%E3%82%92%E5%88%9D%E8%A7%A6%E3%80%82%E6%9C%AC%E4%BD%93%E3%82%92%E3%82%AE%E3%83%A5%E3%83%83%E3%81%A8%E6%8F%A1%E3%82%8B%E3%81%A8_Google_Assistant_%E3%81%8C%E7%AB%8B%E3%81%A1%E4%B8%8A%E3%81%8C%E3%82%8B%E3%81%AE%E3%81%8C%E3%81%8A%E3%82%82%E3%81%97%E3%82%8D%E3%81%84%E3%80%82_%E3%83%AF%E3%82%B7%E3%83%B3%E3%83%88%E3%83%B3DC_%2844519013945%29.jpg/440px-thumbnail.jpg 2x" data-file-width="1080" data-file-height="1146"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Pixel_3_%E3%81%A8_Pixel_3_XL_%E3%82%92%E5%88%9D%E8%A7%A6%E3%80%82%E6%9C%AC%E4%BD%93%E3%82%92%E3%82%AE%E3%83%A5%E3%83%83%E3%81%A8%E6%8F%A1%E3%82%8B%E3%81%A8_Google_Assistant_%E3%81%8C%E7%AB%8B%E3%81%A1%E4%B8%8A%E3%81%8C%E3%82%8B%E3%81%AE%E3%81%8C%E3%81%8A%E3%82%82%E3%81%97%E3%82%8D%E3%81%84%E3%80%82_%E3%83%AF%E3%82%B7%E3%83%B3%E3%83%88%E3%83%B3DC_(44519013945).jpg" class="internal" title="Enlarge"></a></div>
            Google Pixel smartphones on display in a store
         </div>
      </div>
   </div>
   <p>In January 2010, Google released <a href="/wiki/Nexus_One" title="Nexus One">Nexus One</a>, the first Android phone under its own brand.<sup id="cite_ref-147" class="reference"><a href="#cite_note-147">[146]</a></sup> It spawned a number of phones and tablets under the "<a href="/wiki/Google_Nexus" title="Google Nexus">Nexus</a>" branding<sup id="cite_ref-148" class="reference"><a href="#cite_note-148">[147]</a></sup> until its eventual discontinuation in 2016, replaced by a new brand called <a href="/wiki/Google_Pixel" title="Google Pixel">Pixel</a>.<sup id="cite_ref-Pixel_inside_story_149-0" class="reference"><a href="#cite_note-Pixel_inside_story-149">[148]</a></sup></p>
   <p>In 2011, the <a href="/wiki/Chromebook" title="Chromebook">Chromebook</a> was introduced, which runs on <a href="/wiki/Chrome_OS" title="Chrome OS">Chrome OS</a>.<sup id="cite_ref-150" class="reference"><a href="#cite_note-150">[149]</a></sup></p>
   <p>In July 2013, Google introduced the <a href="/wiki/Chromecast" title="Chromecast">Chromecast</a> dongle, which allows users to stream content from their smartphones to televisions.<sup id="cite_ref-151" class="reference"><a href="#cite_note-151">[150]</a></sup><sup id="cite_ref-152" class="reference"><a href="#cite_note-152">[151]</a></sup></p>
   <p>In June 2014, Google announced <a href="/wiki/Google_Cardboard" title="Google Cardboard">Google Cardboard</a>, a simple cardboard viewer that lets user place their smartphone in a special front compartment to view <a href="/wiki/Virtual_reality" title="Virtual reality">virtual reality</a> (VR) media.<sup id="cite_ref-153" class="reference"><a href="#cite_note-153">[152]</a></sup><sup id="cite_ref-154" class="reference"><a href="#cite_note-154">[153]</a></sup></p>
   <ul>
      <li><a href="/wiki/Google_Home" class="mw-redirect" title="Google Home">Google Home</a>, a voice assistant smart speaker that can answer voice queries, play music, find information from apps (calendar, weather etc.), and control third-party smart home appliances (users can tell it to turn on the lights, for example). The Google Home line also includes variants such as the <a href="/wiki/Google_Home_Hub" class="mw-redirect" title="Google Home Hub">Google Nest Hub</a>, <a href="/wiki/Google_Home_Mini" class="mw-redirect" title="Google Home Mini">Google Home Mini</a>, <a href="/wiki/Nest_Hub_Max" class="mw-redirect" title="Nest Hub Max">Nest Hub Max</a>, <a href="/wiki/Google_Nest_(smart_speakers)#Nest_Mini_(second_generation)" title="Google Nest (smart speakers)">Nest Mini (second generation)</a>, and <a href="/wiki/Google_Home_Max" class="mw-redirect" title="Google Home Max">Google Home Max</a><sup id="cite_ref-155" class="reference"><a href="#cite_note-155">[154]</a></sup></li>
      <li><a href="/wiki/Google_Daydream" title="Google Daydream">Daydream View</a> <a href="/wiki/Virtual_reality" title="Virtual reality">virtual reality</a> headset that lets <a href="/wiki/Android_(operating_system)" title="Android (operating system)">Android</a> users with compatible Daydream-ready smartphones put their phones in the headset and enjoy VR content.<sup id="cite_ref-156" class="reference"><a href="#cite_note-156">[155]</a></sup></li>
      <li><a href="/wiki/Google_Nest_Wifi" title="Google Nest Wifi">Google Wifi</a>, a connected set of <a href="/wiki/Wi-Fi" title="Wi-Fi">Wi-Fi</a> routers to simplify and extend coverage of home Wi-Fi.<sup id="cite_ref-157" class="reference"><a href="#cite_note-157">[156]</a></sup></li>
   </ul>
   <h3><span class="mw-headline" id="Enterprise_services">Enterprise services<span class="anchor" id="Enterprise_products"></span></span></h3>
   <div role="note" class="hatnote navigation-not-searchable">Main articles: <a href="/wiki/Google_Workspace" title="Google Workspace">Google Workspace</a> and <a href="/wiki/Google_Cloud_Platform" title="Google Cloud Platform">Google Cloud Platform</a></div>
   <p><a href="/wiki/Google_Workspace" title="Google Workspace">Google Workspace</a>, (formerly G Suite until October 2020<sup id="cite_ref-158" class="reference"><a href="#cite_note-158">[157]</a></sup>) is a monthly subscription offering for organizations and businesses to get access to a collection of Google's services, including <a href="/wiki/Gmail" title="Gmail">Gmail</a>, <a href="/wiki/Google_Drive" title="Google Drive">Google Drive</a> and <a href="/wiki/Google_Docs" title="Google Docs">Google Docs</a>, <a href="/wiki/Google_Sheets" title="Google Sheets">Google Sheets</a> and <a href="/wiki/Google_Slides" title="Google Slides">Google Slides</a>, with additional administrative tools, unique domain names, and 24/7 support.<sup id="cite_ref-159" class="reference"><a href="#cite_note-159">[158]</a></sup></p>
   <p>On September 24, 2012,<sup id="cite_ref-160" class="reference"><a href="#cite_note-160">[159]</a></sup> Google launched <a href="/wiki/Google_for_Entrepreneurs" class="mw-redirect" title="Google for Entrepreneurs">Google for Entrepreneurs</a>, a largely not-for-profit <a href="/wiki/Business_incubator" title="Business incubator">business incubator</a> providing startups with <a href="/wiki/Coworking" title="Coworking">co-working spaces</a> known as Campuses, with assistance to startup founders that may include workshops, conferences, and mentorships.<sup id="cite_ref-161" class="reference"><a href="#cite_note-161">[160]</a></sup> Presently, there are 7 Campus locations in <a href="/wiki/Berlin" title="Berlin">Berlin</a>, <a href="/wiki/London" title="London">London</a>, <a href="/wiki/Madrid" title="Madrid">Madrid</a>, <a href="/wiki/Seoul" title="Seoul">Seoul</a>, <a href="/wiki/S%C3%A3o_Paulo" title="São Paulo">São Paulo</a>, <a href="/wiki/Tel_Aviv" title="Tel Aviv">Tel Aviv</a>, and <a href="/wiki/Warsaw" title="Warsaw">Warsaw</a>.</p>
   <p>On March 15, 2016, Google announced the introduction of Google Analytics 360 Suite, "a set of integrated data and marketing analytics products, designed specifically for the needs of enterprise-class marketers" which can be integrated with <a href="/wiki/BigQuery" title="BigQuery">BigQuery</a> on the Google Cloud Platform. Among other things, the suite is designed to help "enterprise class marketers" "see the complete customer journey", generate "useful insights", and "deliver engaging experiences to the right people".<sup id="cite_ref-162" class="reference"><a href="#cite_note-162">[161]</a></sup> Jack Marshall of <i><a href="/wiki/The_Wall_Street_Journal" title="The Wall Street Journal">The Wall Street Journal</a></i> wrote that the suite competes with existing marketing cloud offerings by companies including <a href="/wiki/Adobe_Systems" class="mw-redirect" title="Adobe Systems">Adobe</a>, <a href="/wiki/Oracle_Corporation" title="Oracle Corporation">Oracle</a>, <a href="/wiki/Salesforce.com" class="mw-redirect" title="Salesforce.com">Salesforce</a>, and <a href="/wiki/IBM" title="IBM">IBM</a>.<sup id="cite_ref-163" class="reference"><a href="#cite_note-163">[162]</a></sup></p>
   <h3><span class="mw-headline" id="Internet_services">Internet services</span></h3>
   <p>In February 2010, Google announced the <a href="/wiki/Google_Fiber" title="Google Fiber">Google Fiber</a> project, with experimental plans to build an ultra-high-speed broadband network for 50,000 to 500,000 customers in one or more American cities.<sup id="cite_ref-164" class="reference"><a href="#cite_note-164">[163]</a></sup><sup id="cite_ref-165" class="reference"><a href="#cite_note-165">[164]</a></sup> Following Google's corporate restructure to make <a href="/wiki/Alphabet_Inc." title="Alphabet Inc.">Alphabet Inc.</a> its parent company, Google Fiber was moved to Alphabet's Access division.<sup id="cite_ref-166" class="reference"><a href="#cite_note-166">[165]</a></sup><sup id="cite_ref-167" class="reference"><a href="#cite_note-167">[166]</a></sup></p>
   <p>In April 2015, Google announced <a href="/wiki/Project_Fi" class="mw-redirect" title="Project Fi">Project Fi</a>, a mobile virtual network operator, that combines Wi-Fi and cellular networks from different telecommunication providers in an effort to enable seamless connectivity and fast Internet signal.<sup id="cite_ref-168" class="reference"><a href="#cite_note-168">[167]</a></sup><sup id="cite_ref-169" class="reference"><a href="#cite_note-169">[168]</a></sup><sup id="cite_ref-170" class="reference"><a href="#cite_note-170">[169]</a></sup></p>
   <p>In September 2016, Google began its Google Station initiative, a project for public Wi-Fi at railway stations in India. Caesar Sengupta, VP for Google's next billion users, told <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i> that 15,000 people get online for the first time thanks to Google Station and that 3.5 million people use the service every month. The expansion meant that Google was looking for partners around the world to further develop the initiative, which promised "high-quality, secure, easily accessible Wi-Fi".<sup id="cite_ref-171" class="reference"><a href="#cite_note-171">[170]</a></sup> By December, Google Station had been deployed at 100 railway stations,<sup id="cite_ref-172" class="reference"><a href="#cite_note-172">[171]</a></sup> and in February, Google announced its intention to expand beyond railway stations, with a plan to bring citywide Wi-Fi to <a href="/wiki/Pune" title="Pune">Pune</a>.<sup id="cite_ref-173" class="reference"><a href="#cite_note-173">[172]</a></sup><sup id="cite_ref-174" class="reference"><a href="#cite_note-174">[173]</a></sup></p>
   <h3><span class="mw-headline" id="Other_products">Other products</span></h3>
   <p>In May 2011, Google announced <a href="/wiki/Google_Wallet" class="mw-redirect" title="Google Wallet">Google Wallet</a>, a mobile application for wireless payments.<sup id="cite_ref-175" class="reference"><a href="#cite_note-175">[174]</a></sup></p>
   <p>In 2013, Google launched <a href="/wiki/Google_Shopping_Express" class="mw-redirect" title="Google Shopping Express">Google Shopping Express</a>, a delivery service initially available only in San Francisco and Silicon Valley.<sup id="cite_ref-176" class="reference"><a href="#cite_note-176">[175]</a></sup></p>
   <h2><span class="mw-headline" id="Corporate_affairs">Corporate affairs</span></h2>
   <h3><span class="mw-headline" id="Stock_price_performance_and_quarterly_earnings">Stock price performance and quarterly earnings</span></h3>
   <p>Google's <a href="/wiki/Initial_public_offering" title="Initial public offering">initial public offering</a> (IPO) took place on August 19, 2004. At IPO, the company offered 19,605,052 shares at a price of $85 per share.<sup id="cite_ref-IPO_60-1" class="reference"><a href="#cite_note-IPO-60">[59]</a></sup><sup id="cite_ref-:1_61-1" class="reference"><a href="#cite_note-:1-61">[60]</a></sup> The sale of $1.67 billion gave Google a <a href="/wiki/Market_capitalization" title="Market capitalization">market capitalization</a> of more than $23 billion.<sup id="cite_ref-washpost_64-1" class="reference"><a href="#cite_note-washpost-64">[63]</a></sup> The stock performed well after the IPO, with shares hitting $350 for the first time on October 31, 2007,<sup id="cite_ref-177" class="reference"><a href="#cite_note-177">[176]</a></sup> primarily because of strong sales and earnings in the <a href="/wiki/Online_advertising" title="Online advertising">online advertising</a> market.<sup id="cite_ref-bowlingforgoogle_178-0" class="reference"><a href="#cite_note-bowlingforgoogle-178">[177]</a></sup> The surge in stock price was fueled mainly by individual investors, as opposed to large institutional investors and <a href="/wiki/Mutual_fund" title="Mutual fund">mutual funds</a>.<sup id="cite_ref-bowlingforgoogle_178-1" class="reference"><a href="#cite_note-bowlingforgoogle-178">[177]</a></sup> GOOG shares split into GOOG <a href="/wiki/Class_C_share" class="mw-redirect" title="Class C share">class C shares</a> and GOOGL <a href="/wiki/Class_A_share" title="Class A share">class A shares</a>.<sup id="cite_ref-179" class="reference"><a href="#cite_note-179">[178]</a></sup> The company is listed on the <a href="/wiki/NASDAQ" class="mw-redirect" title="NASDAQ">NASDAQ</a> stock exchange under the <a href="/wiki/Ticker_symbol" title="Ticker symbol">ticker symbols</a> GOOGL and GOOG, and on the <a href="/wiki/Frankfurt_Stock_Exchange" title="Frankfurt Stock Exchange">Frankfurt Stock Exchange</a> under the ticker symbol GGQ1. These ticker symbols now refer to Alphabet Inc., Google's holding company, since the fourth quarter of 2015.<sup class="plainlinks noexcerpt noprint asof-tag update" style="display:none;"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Google&amp;action=edit">[update]</a></sup><sup id="cite_ref-180" class="reference"><a href="#cite_note-180">[179]</a></sup></p>
   <p>In the third-quarter of 2005, Google reported a 700% increase in profit, largely due to large companies shifting their advertising strategies from newspapers, magazines, and television to the Internet.<sup id="cite_ref-181" class="reference"><a href="#cite_note-181">[180]</a></sup><sup id="cite_ref-182" class="reference"><a href="#cite_note-182">[181]</a></sup><sup id="cite_ref-183" class="reference"><a href="#cite_note-183">[182]</a></sup></p>
   <p>For the 2006 fiscal year, the company reported $10.492 billion in total advertising revenues and only $112 million in licensing and other revenues.<sup id="cite_ref-10-K_184-0" class="reference"><a href="#cite_note-10-K-184">[183]</a></sup> In 2011, 96% of Google's revenue was derived from its advertising programs.<sup id="cite_ref-Google-Inc-Jan-2012-10-K_185-0" class="reference"><a href="#cite_note-Google-Inc-Jan-2012-10-K-185">[184]</a></sup> </p>
   <p>The year 2012 was the first time that Google generated $50 billion in annual revenue for the first time in 2012, generating $38 billion the previous year. In January 2013, then-CEO Larry Page commented, "We ended 2012 with a strong quarter ... Revenues were up 36% year-on-year, and 8% quarter-on-quarter. And we hit $50 billion in revenues for the first time last year – not a bad achievement in just a decade and a half."<sup id="cite_ref-186" class="reference"><a href="#cite_note-186">[185]</a></sup></p>
   <p>Google's consolidated revenue for the third quarter of 2013 was reported in mid-October 2013 as $14.89 billion, a 12 percent increase compared to the previous quarter.<sup id="cite_ref-187" class="reference"><a href="#cite_note-187">[186]</a></sup> Google's Internet business was responsible for $10.8 billion of this total, with an increase in the number of users' clicks on advertisements.<sup id="cite_ref-188" class="reference"><a href="#cite_note-188">[187]</a></sup> By January 2014, Google's market capitalization had grown to $397 billion.<sup id="cite_ref-Marketwatch_189-0" class="reference"><a href="#cite_note-Marketwatch-189">[188]</a></sup></p>
   <h3><span class="mw-headline" id="Tax_avoidance_strategies">Tax avoidance strategies</span></h3>
   <div role="note" class="hatnote navigation-not-searchable">Further information: <a href="/wiki/Corporation_tax_in_the_Republic_of_Ireland#Multinational_tax_schemes" title="Corporation tax in the Republic of Ireland">Corporation tax in the Republic of Ireland §&nbsp;Multinational tax schemes</a>, and <a href="/wiki/Google_tax" title="Google tax">Google tax</a></div>
   <p>Google uses various <a href="/wiki/Tax_avoidance" title="Tax avoidance">tax avoidance</a> strategies. On the <a href="/wiki/List_of_the_largest_information_technology_companies" class="mw-redirect" title="List of the largest information technology companies">list of the largest information technology companies</a>, it pays the lowest taxes to the countries of origin of its revenues. Google between 2007 and 2010 saved $3.1 billion in taxes by shuttling non-U.S. profits through <a href="/wiki/Ireland" title="Ireland">Ireland</a> and the <a href="/wiki/Netherlands" title="Netherlands">Netherlands</a> and then to <a href="/wiki/Bermuda" title="Bermuda">Bermuda</a>. Such techniques lower its non-U.S. tax rate to 2.3 per cent, while normally the corporate tax rate in for instance the UK is 28 per cent.<sup id="cite_ref-190" class="reference"><a href="#cite_note-190">[189]</a></sup> This has reportedly sparked a French investigation into Google's <a href="/wiki/Transfer_pricing" title="Transfer pricing">transfer pricing</a> practices.<sup id="cite_ref-191" class="reference"><a href="#cite_note-191">[190]</a></sup></p>
   <p>Google said it overhauled its controversial global tax structure and consolidated all of its intellectual property holdings back to the US.<sup id="cite_ref-192" class="reference"><a href="#cite_note-192">[191]</a></sup></p>
   <p>Google Vice-President <a href="/wiki/Matt_Brittin" title="Matt Brittin">Matt Brittin</a> testified to the <a href="/wiki/Public_Accounts_Committee_(United_Kingdom)" title="Public Accounts Committee (United Kingdom)">Public Accounts Committee</a> of the UK House of Commons that his UK sales team made no sales and hence owed no sales taxes to the UK.<sup id="cite_ref-193" class="reference"><a href="#cite_note-193">[192]</a></sup> In January 2016, Google reached a settlement with the UK to pay £130m in back taxes plus higher taxes in future.<sup id="cite_ref-194" class="reference"><a href="#cite_note-194">[193]</a></sup> In 2017, Google channeled $22.7 billion from the Netherlands to Bermuda to reduce its tax bill.<sup id="cite_ref-195" class="reference"><a href="#cite_note-195">[194]</a></sup></p>
   <p>In 2013, Google ranked 5th in <a href="/wiki/Lobbying_in_the_United_States" title="Lobbying in the United States">lobbying</a> spending, up from 213th in 2003. In 2012, the company ranked 2nd in campaign donations of technology and Internet sections.<sup id="cite_ref-lobby1_196-0" class="reference"><a href="#cite_note-lobby1-196">[195]</a></sup></p>
   <h3><span class="mw-headline" id="Corporate_identity">Corporate identity</span></h3>
   <div role="note" class="hatnote navigation-not-searchable">Further information: <a href="/wiki/History_of_Google#Name" title="History of Google">History of Google §&nbsp;Name</a>, <a href="/wiki/Google_(verb)" title="Google (verb)">Google (verb)</a>, <a href="/wiki/Google_logo" title="Google logo">Google logo</a>, <a href="/wiki/Google_Doodle" title="Google Doodle">Google Doodle</a>, <a href="/wiki/List_of_Google_April_Fools%27_Day_jokes" title="List of Google April Fools' Day jokes">List of Google April Fools' Day jokes</a>, and <a href="/wiki/List_of_Google_Easter_eggs" title="List of Google Easter eggs">List of Google Easter eggs</a></div>
   <div class="thumb tright">
      <div class="thumbinner" style="width:202px;">
         <a href="/wiki/File:Google_logo_(2013-2015).svg" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Google_logo_%282013-2015%29.svg/200px-Google_logo_%282013-2015%29.svg.png" decoding="async" width="200" height="69" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Google_logo_%282013-2015%29.svg/300px-Google_logo_%282013-2015%29.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Google_logo_%282013-2015%29.svg/400px-Google_logo_%282013-2015%29.svg.png 2x" data-file-width="750" data-file-height="258"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Google_logo_(2013-2015).svg" class="internal" title="Enlarge"></a></div>
            Google's logo from 2013 to 2015
         </div>
      </div>
   </div>
   <p>The name "Google" originated from a misspelling of "<a href="/wiki/Googol" title="Googol">googol</a>",<sup id="cite_ref-197" class="reference"><a href="#cite_note-197">[196]</a></sup><sup id="cite_ref-Hanley_198-0" class="reference"><a href="#cite_note-Hanley-198">[197]</a></sup> which refers to the number represented by a 1 followed by one-hundred zeros. Page and Brin write in their original paper on <a href="/wiki/PageRank" title="PageRank">PageRank</a>:<sup id="cite_ref-originalpaper_31-1" class="reference"><a href="#cite_note-originalpaper-31">[30]</a></sup> "We chose our systems name, Google, because it is a common spelling of googol, or 10<sup>100</sup> and fits well with our goal of building very large-scale search engines." Having found its way increasingly into everyday language, the verb "<a href="/wiki/Google_(verb)" title="Google (verb)">google</a>" was added to the <i><a href="/wiki/Merriam-Webster_Collegiate_Dictionary" class="mw-redirect" title="Merriam-Webster Collegiate Dictionary">Merriam Webster Collegiate Dictionary</a></i> and the <i><a href="/wiki/Oxford_English_Dictionary" title="Oxford English Dictionary">Oxford English Dictionary</a></i> in 2006, meaning "to use the Google search engine to obtain information on the Internet."<sup id="cite_ref-199" class="reference"><a href="#cite_note-199">[198]</a></sup><sup id="cite_ref-200" class="reference"><a href="#cite_note-200">[199]</a></sup> Google's <a href="/wiki/Mission_statement" title="Mission statement">mission statement</a>, from the outset, was "to organize the world's information and make it universally accessible and useful",<sup id="cite_ref-201" class="reference"><a href="#cite_note-201">[200]</a></sup> and its unofficial slogan is "<a href="/wiki/Don%27t_be_evil" title="Don't be evil">Don't be evil</a>".<sup id="cite_ref-202" class="reference"><a href="#cite_note-202">[201]</a></sup> In October 2015, a related motto was adopted in the Alphabet corporate code of conduct by the phrase: "Do the right thing".<sup id="cite_ref-203" class="reference"><a href="#cite_note-203">[202]</a></sup> The original motto was retained in the code of conduct of Google, now a subsidiary of Alphabet.</p>
   <p>The original <a href="/wiki/Google_logo" title="Google logo">Google logo</a> was designed by Sergey Brin.<sup id="cite_ref-204" class="reference"><a href="#cite_note-204">[203]</a></sup> Since 1998,<sup class="plainlinks noexcerpt noprint asof-tag update" style="display:none;"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Google&amp;action=edit">[update]</a></sup> Google has been designing special, temporary alternate logos to place on their homepage intended to celebrate holidays, events, achievements and people. The first <a href="/wiki/Google_Doodle" title="Google Doodle">Google Doodle</a> was in honor of the <a href="/wiki/Burning_Man" title="Burning Man">Burning Man Festival</a> of 1998.<sup id="cite_ref-205" class="reference"><a href="#cite_note-205">[204]</a></sup><sup id="cite_ref-206" class="reference"><a href="#cite_note-206">[205]</a></sup> The doodle was designed by <a href="/wiki/Larry_Page" title="Larry Page">Larry Page</a> and <a href="/wiki/Sergey_Brin" title="Sergey Brin">Sergey Brin</a> to notify users of their absence in case the servers crashed. Subsequent Google Doodles were designed by an outside contractor, until Larry and Sergey asked then-<a href="/wiki/Intern" class="mw-redirect" title="Intern">intern</a> <a href="/wiki/Dennis_Hwang" title="Dennis Hwang">Dennis Hwang</a> to design a logo for <a href="/wiki/Bastille_Day" title="Bastille Day">Bastille Day</a> in 2000. From that point onward, Doodles have been organized and created by a team of employees termed "Doodlers".<sup id="cite_ref-207" class="reference"><a href="#cite_note-207">[206]</a></sup></p>
   <p>Google has a tradition of creating <a href="/wiki/April_Fools%27_Day" title="April Fools' Day">April Fools' Day</a> jokes. Its first on April 1, 2000 was <a href="/wiki/Google%27s_hoaxes#2000" class="mw-redirect" title="Google's hoaxes">Google MentalPlex</a> which allegedly featured the use of mental power to search the web.<sup id="cite_ref-mentalplex_208-0" class="reference"><a href="#cite_note-mentalplex-208">[207]</a></sup> In 2007, Google announced a free Internet service called <a href="/wiki/TiSP" class="mw-redirect" title="TiSP">TiSP</a>, or Toilet Internet Service Provider, where one obtained a connection by flushing one end of a <a href="/wiki/Optical_fiber" title="Optical fiber">fiber-optic</a> cable down their toilet.<sup id="cite_ref-TiSP_209-0" class="reference"><a href="#cite_note-TiSP-209">[208]</a></sup></p>
   <p>Google's services contain <a href="/wiki/Easter_egg_(media)" title="Easter egg (media)">easter eggs</a>, such as the <a href="/wiki/Swedish_Chef" title="Swedish Chef">Swedish Chef</a>'s "Bork bork bork," <a href="/wiki/Pig_Latin" title="Pig Latin">Pig Latin</a>, "Hacker" or <a href="/wiki/Leet" title="Leet">leetspeak</a>, <a href="/wiki/Elmer_Fudd" title="Elmer Fudd">Elmer Fudd</a>, <a href="/wiki/International_Talk_Like_a_Pirate_Day" title="International Talk Like a Pirate Day">Pirate</a>, and <a href="/wiki/Klingon_language" title="Klingon language">Klingon</a> as language selections for its search engine.<sup id="cite_ref-210" class="reference"><a href="#cite_note-210">[209]</a></sup> When searching for the word "<a href="/wiki/Anagram" title="Anagram">anagram</a>," meaning a rearrangement of letters from one word to form other valid words, Google's suggestion feature displays "Did you mean: nag a ram?"<sup id="cite_ref-211" class="reference"><a href="#cite_note-211">[210]</a></sup></p>
   <h3><span class="mw-headline" id="Workplace_culture">Workplace culture<span class="anchor" id="Innovation_Time_Off"></span><span class="anchor" id="Employees"></span></span></h3>
   <div class="thumb tleft">
      <div class="thumbinner" style="width:222px;">
         <a href="/wiki/File:Pride_in_London_2016_-_Google_participating_in_the_parade.png" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Pride_in_London_2016_-_Google_participating_in_the_parade.png/220px-Pride_in_London_2016_-_Google_participating_in_the_parade.png" decoding="async" width="220" height="147" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Pride_in_London_2016_-_Google_participating_in_the_parade.png/330px-Pride_in_London_2016_-_Google_participating_in_the_parade.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Pride_in_London_2016_-_Google_participating_in_the_parade.png/440px-Pride_in_London_2016_-_Google_participating_in_the_parade.png 2x" data-file-width="5184" data-file-height="3456"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Pride_in_London_2016_-_Google_participating_in_the_parade.png" class="internal" title="Enlarge"></a></div>
            Google employees marching in the <a href="/wiki/Pride_in_London" title="Pride in London">Pride in London</a> parade in 2016
         </div>
      </div>
   </div>
   <p>On <i><a href="/wiki/Fortune_(magazine)" title="Fortune (magazine)">Fortune</a></i> magazine's list of the best companies to work for, Google ranked first in 2007, 2008 and 2012,<sup id="cite_ref-best_company_212-0" class="reference"><a href="#cite_note-best_company-212">[211]</a></sup><sup id="cite_ref-213" class="reference"><a href="#cite_note-213">[212]</a></sup><sup id="cite_ref-214" class="reference"><a href="#cite_note-214">[213]</a></sup> and fourth in 2009 and 2010.<sup id="cite_ref-215" class="reference"><a href="#cite_note-215">[214]</a></sup><sup id="cite_ref-216" class="reference"><a href="#cite_note-216">[215]</a></sup> Google was also nominated in 2010 to be the world's most attractive employer to graduating students in the Universum Communications talent attraction index.<sup id="cite_ref-217" class="reference"><a href="#cite_note-217">[216]</a></sup> Google's corporate philosophy includes principles such as "you can make money without doing evil," "you can be serious without a suit," and "work should be challenging and the challenge should be fun."<sup id="cite_ref-218" class="reference"><a href="#cite_note-218">[217]</a></sup></p>
   <p>As of September 30, 2020,<sup class="plainlinks noexcerpt noprint asof-tag update" style="display:none;"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Google&amp;action=edit">[update]</a></sup> Alphabet Inc. had 132,121 employees,<sup id="cite_ref-219" class="reference"><a href="#cite_note-219">[218]</a></sup> of which more than 100,000 worked for Google.<sup id="cite_ref-:0_10-1" class="reference"><a href="#cite_note-:0-10">[9]</a></sup> Google's 2020<sup class="plainlinks noexcerpt noprint asof-tag update" style="display:none;"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Google&amp;action=edit">[update]</a></sup> diversity report states that 32 percent of its workforce are women and 68 percent are men, with the ethnicity of its workforce being predominantly white (51.7%) and Asian (41.9%).<sup id="cite_ref-220" class="reference"><a href="#cite_note-220">[219]</a></sup> Within tech roles, 23.6 percent were women; and 26.7 percent of leadership roles were held by women.<sup id="cite_ref-221" class="reference"><a href="#cite_note-221">[220]</a></sup> In addition to its 100,000+ full-time employees, Google used about 121,000 temporary workers and contractors, as of March&nbsp;2019<sup class="plainlinks noexcerpt noprint asof-tag update" style="display:none;"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Google&amp;action=edit">[update]</a></sup>.<sup id="cite_ref-:0_10-2" class="reference"><a href="#cite_note-:0-10">[9]</a></sup></p>
   <p>Google's employees are hired based on a hierarchical system. Employees are split into six hierarchies based on experience and can range "from entry-level data center workers at level one to managers and experienced engineers at level six."<sup id="cite_ref-222" class="reference"><a href="#cite_note-222">[221]</a></sup> As a motivation technique, Google uses a policy known as <a href="/wiki/Innovation_Time_Off" class="mw-redirect" title="Innovation Time Off">Innovation Time Off</a>, where Google engineers are encouraged to spend 20% of their work time on projects that interest them. Some of Google's services, such as <a href="/wiki/Gmail" title="Gmail">Gmail</a>, <a href="/wiki/Google_News" title="Google News">Google News</a>, <a href="/wiki/Orkut" title="Orkut">Orkut</a>, and <a href="/wiki/AdSense" class="mw-redirect" title="AdSense">AdSense</a> originated from these independent endeavors.<sup id="cite_ref-223" class="reference"><a href="#cite_note-223">[222]</a></sup> In a talk at Stanford University, <a href="/wiki/Marissa_Mayer" title="Marissa Mayer">Marissa Mayer</a>, Google's Vice-President of Search Products and User Experience until July 2012, showed that half of all new product launches in the second half of 2005 had originated from the Innovation Time Off.<sup id="cite_ref-224" class="reference"><a href="#cite_note-224">[223]</a></sup></p>
   <p>In 2005, articles in <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i><sup id="cite_ref-225" class="reference"><a href="#cite_note-225">[224]</a></sup> and other sources began suggesting that Google had lost its anti-corporate, no evil philosophy.<sup id="cite_ref-226" class="reference"><a href="#cite_note-226">[225]</a></sup><sup id="cite_ref-227" class="reference"><a href="#cite_note-227">[226]</a></sup><sup id="cite_ref-228" class="reference"><a href="#cite_note-228">[227]</a></sup> In an effort to maintain the company's unique culture, Google designated a Chief Culture Officer whose purpose was to develop and maintain the culture and work on ways to keep true to the core values that the company was founded on.<sup id="cite_ref-CCO_229-0" class="reference"><a href="#cite_note-CCO-229">[228]</a></sup> Google has also faced allegations of <a href="/wiki/Sexism" title="Sexism">sexism</a> and <a href="/wiki/Ageism" title="Ageism">ageism</a> from former employees.<sup id="cite_ref-230" class="reference"><a href="#cite_note-230">[229]</a></sup><sup id="cite_ref-231" class="reference"><a href="#cite_note-231">[230]</a></sup> In 2013, a <a href="/wiki/High-Tech_Employee_Antitrust_Litigation" title="High-Tech Employee Antitrust Litigation">class action against</a> several <a href="/wiki/Silicon_Valley" title="Silicon Valley">Silicon Valley</a> companies, including Google, was filed for alleged "no cold call" agreements which restrained the recruitment of high-tech employees.<sup id="cite_ref-232" class="reference"><a href="#cite_note-232">[231]</a></sup> In a lawsuit filed January 8, 2018, multiple employees and job applicants alleged Google discriminated against a class defined by their “conservative political views[,] male gender[,] and/or […] Caucasian or Asian race”.<sup id="cite_ref-:4_233-0" class="reference"><a href="#cite_note-:4-233">[232]</a></sup></p>
   <p>On January 25, 2020, the formation of an international workers union of Google employees, Alpha Global, was announced.<sup id="cite_ref-234" class="reference"><a href="#cite_note-234">[233]</a></sup> The coalition is made up of "13 different unions representing workers in 10 countries, including the United States, United Kingdom, and Switzerland."<sup id="cite_ref-:5_235-0" class="reference"><a href="#cite_note-:5-235">[234]</a></sup> The group is affiliated with <a href="/wiki/UNI_Global_Union" title="UNI Global Union">UNI Global Union</a>, which represents nearly 20 million international workers from various unions and federations. The formation of the union is in response to persistent allegations of mistreatment of Google employees and a toxic workplace culture.<sup id="cite_ref-:5_235-1" class="reference"><a href="#cite_note-:5-235">[234]</a></sup><sup id="cite_ref-236" class="reference"><a href="#cite_note-236">[235]</a></sup><sup id="cite_ref-:4_233-1" class="reference"><a href="#cite_note-:4-233">[232]</a></sup> Google had previously been accused of surveilling and firing employees who were suspected of organizing a workers union.<sup id="cite_ref-237" class="reference"><a href="#cite_note-237">[236]</a></sup></p>
   <h3><span class="mw-headline" id="Office_locations">Office locations<span class="anchor" id="Office_locations_and_headquarters"></span></span></h3>
   <div role="note" class="hatnote navigation-not-searchable">Further information: <a href="/wiki/Googleplex" title="Googleplex">Googleplex</a></div>
   <div class="thumb tright">
      <div class="thumbinner" style="width:222px;">
         <a href="/wiki/File:111_Eighth_Avenue.jpg" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/e/ee/111_Eighth_Avenue.jpg/220px-111_Eighth_Avenue.jpg" decoding="async" width="220" height="149" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/e/ee/111_Eighth_Avenue.jpg/330px-111_Eighth_Avenue.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/e/ee/111_Eighth_Avenue.jpg/440px-111_Eighth_Avenue.jpg 2x" data-file-width="3911" data-file-height="2653"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:111_Eighth_Avenue.jpg" class="internal" title="Enlarge"></a></div>
            Google's New York City office building houses its largest advertising sales team.
         </div>
      </div>
   </div>
   <div class="thumb tright">
      <div class="thumbinner" style="width:222px;">
         <a href="/wiki/File:Google_at_111_Richmond_Street_West_in_Toronto_(cropped).jpg" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Google_at_111_Richmond_Street_West_in_Toronto_%28cropped%29.jpg/220px-Google_at_111_Richmond_Street_West_in_Toronto_%28cropped%29.jpg" decoding="async" width="220" height="98" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Google_at_111_Richmond_Street_West_in_Toronto_%28cropped%29.jpg/330px-Google_at_111_Richmond_Street_West_in_Toronto_%28cropped%29.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Google_at_111_Richmond_Street_West_in_Toronto_%28cropped%29.jpg/440px-Google_at_111_Richmond_Street_West_in_Toronto_%28cropped%29.jpg 2x" data-file-width="3156" data-file-height="1406"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Google_at_111_Richmond_Street_West_in_Toronto_(cropped).jpg" class="internal" title="Enlarge"></a></div>
            Google's <a href="/wiki/Toronto" title="Toronto">Toronto</a> office.
         </div>
      </div>
   </div>
   <p>Google's headquarters in <a href="/wiki/Mountain_View,_California" title="Mountain View, California">Mountain View</a>, California is referred to as "the <a href="/wiki/Googleplex" title="Googleplex">Googleplex</a>", a play on words on the number <a href="/wiki/Googolplex" title="Googolplex">googolplex</a> and the headquarters itself being a <i>complex</i> of buildings. Internationally, Google has over 78 offices in more than 50 countries.<sup id="cite_ref-238" class="reference"><a href="#cite_note-238">[237]</a></sup></p>
   <p>In 2006, Google moved into about 300,000 square feet (27,900&nbsp;m<sup>2</sup>) of office space at <a href="/wiki/111_Eighth_Avenue" title="111 Eighth Avenue">111 Eighth Avenue</a> in <a href="/wiki/Manhattan" title="Manhattan">Manhattan</a>, <a href="/wiki/New_York_City" title="New York City">New York City</a>. The office was designed and built specially for Google, and houses its largest advertising sales team.<sup id="cite_ref-239" class="reference"><a href="#cite_note-239">[238]</a></sup> In 2010, Google bought the building housing the headquarter, in a deal that valued the property at around $1.9 billion.<sup id="cite_ref-240" class="reference"><a href="#cite_note-240">[239]</a></sup><sup id="cite_ref-241" class="reference"><a href="#cite_note-241">[240]</a></sup> In March 2018, Google's parent company Alphabet bought the nearby <a href="/wiki/Chelsea_Market" title="Chelsea Market">Chelsea Market</a> building for $2.4 billion. The sale is touted as one of the most expensive real estate transactions for a single building in the history of New York.<sup id="cite_ref-242" class="reference"><a href="#cite_note-242">[241]</a></sup><sup id="cite_ref-243" class="reference"><a href="#cite_note-243">[242]</a></sup><sup id="cite_ref-244" class="reference"><a href="#cite_note-244">[243]</a></sup><sup id="cite_ref-245" class="reference"><a href="#cite_note-245">[244]</a></sup> In November 2018, Google announced its plan to expand its New York City office to a capacity of 12,000 employees.<sup id="cite_ref-246" class="reference"><a href="#cite_note-246">[245]</a></sup> The same December, it was announced that a $1 billion, 1,700,000-square-foot (160,000&nbsp;m<sup>2</sup>) headquarters for Google would be built in Manhattan's <a href="/wiki/Hudson_Square" title="Hudson Square">Hudson Square</a> neighborhood.<sup id="cite_ref-247" class="reference"><a href="#cite_note-247">[246]</a></sup><sup id="cite_ref-248" class="reference"><a href="#cite_note-248">[247]</a></sup> Called Google Hudson Square, the new campus is projected to more than double the number of Google employees working in New York City.<sup id="cite_ref-249" class="reference"><a href="#cite_note-249">[248]</a></sup></p>
   <p>By late 2006, Google established a new headquarters for its AdWords division in <a href="/wiki/Ann_Arbor,_Michigan" title="Ann Arbor, Michigan">Ann Arbor, Michigan</a>.<sup id="cite_ref-250" class="reference"><a href="#cite_note-250">[249]</a></sup> In November 2006, Google opened offices on <a href="/wiki/Carnegie_Mellon" class="mw-redirect" title="Carnegie Mellon">Carnegie Mellon</a>'s campus in <a href="/wiki/Pittsburgh" title="Pittsburgh">Pittsburgh</a>, focusing on shopping-related advertisement coding and <a href="/wiki/Smartphone_applications" class="mw-redirect" title="Smartphone applications">smartphone applications</a> and programs.<sup id="cite_ref-251" class="reference"><a href="#cite_note-251">[250]</a></sup><sup id="cite_ref-252" class="reference"><a href="#cite_note-252">[251]</a></sup> Other office locations in the U.S. include <a href="/wiki/Atlanta,_Georgia" class="mw-redirect" title="Atlanta, Georgia">Atlanta, Georgia</a>; <a href="/wiki/Austin,_Texas" title="Austin, Texas">Austin, Texas</a>; <a href="/wiki/Boulder,_Colorado" title="Boulder, Colorado">Boulder, Colorado</a>; <a href="/wiki/Cambridge,_Massachusetts" title="Cambridge, Massachusetts">Cambridge, Massachusetts</a>; <a href="/wiki/San_Francisco" title="San Francisco">San Francisco</a>, <a href="/wiki/California" title="California">California</a>; <a href="/wiki/Seattle,_Washington" class="mw-redirect" title="Seattle, Washington">Seattle, Washington</a>; <a href="/wiki/Kirkland,_Washington" title="Kirkland, Washington">Kirkland, Washington</a>; <a href="/wiki/Birmingham,_Michigan" title="Birmingham, Michigan">Birmingham, Michigan</a>; <a href="/wiki/Reston,_Virginia" title="Reston, Virginia">Reston, Virginia</a>, and <a href="/wiki/Washington,_D.C." title="Washington, D.C.">Washington, D.C.</a><sup id="cite_ref-253" class="reference"><a href="#cite_note-253">[252]</a></sup></p>
   <div class="thumb tright">
      <div class="thumbinner" style="width:222px;">
         <a href="/wiki/File:Google_Headquarters_in_Ireland_Building_Sign.jpg" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/8/85/Google_Headquarters_in_Ireland_Building_Sign.jpg/220px-Google_Headquarters_in_Ireland_Building_Sign.jpg" decoding="async" width="220" height="165" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/8/85/Google_Headquarters_in_Ireland_Building_Sign.jpg/330px-Google_Headquarters_in_Ireland_Building_Sign.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/8/85/Google_Headquarters_in_Ireland_Building_Sign.jpg/440px-Google_Headquarters_in_Ireland_Building_Sign.jpg 2x" data-file-width="2424" data-file-height="1820"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Google_Headquarters_in_Ireland_Building_Sign.jpg" class="internal" title="Enlarge"></a></div>
            Google's Dublin Ireland office, headquarters of Google Ads for Europe
         </div>
      </div>
   </div>
   <p>It also has product research and development operations in cities around the world, namely <a href="/wiki/Sydney" title="Sydney">Sydney</a> (birthplace location of <a href="/wiki/Google_Maps" title="Google Maps">Google Maps</a>)<sup id="cite_ref-254" class="reference"><a href="#cite_note-254">[253]</a></sup> and <a href="/wiki/London" title="London">London</a> (part of <a href="/wiki/Android_(operating_system)" title="Android (operating system)">Android</a> development).<sup id="cite_ref-255" class="reference"><a href="#cite_note-255">[254]</a></sup> In November 2013, Google announced plans for a new <a href="/wiki/London" title="London">London</a> headquarter, a 1 million square foot office able to accommodate 4,500 employees. Recognized as one of the biggest ever commercial property acquisitions at the time of the deal's announcement in January,<sup id="cite_ref-256" class="reference"><a href="#cite_note-256">[255]</a></sup> Google submitted plans for the new headquarter to the <a href="/wiki/Camden_London_Borough_Council" title="Camden London Borough Council">Camden Council</a> in June 2017.<sup id="cite_ref-257" class="reference"><a href="#cite_note-257">[256]</a></sup><sup id="cite_ref-258" class="reference"><a href="#cite_note-258">[257]</a></sup> In May 2015, Google announced its intention to create its own campus in <a href="/wiki/Hyderabad" title="Hyderabad">Hyderabad</a>, India. The new campus, reported to be the company's largest outside the United States, will accommodate 13,000 employees.<sup id="cite_ref-259" class="reference"><a href="#cite_note-259">[258]</a></sup><sup id="cite_ref-260" class="reference"><a href="#cite_note-260">[259]</a></sup></p>
   <h3><span class="mw-headline" id="Infrastructure">Infrastructure</span></h3>
   <div role="note" class="hatnote navigation-not-searchable">Further information: <a href="/wiki/Google_data_centers" title="Google data centers">Google data centers</a></div>
   <p><a href="/wiki/Google_data_centers" title="Google data centers">Google data centers</a> are located in North and South America, Asia, and Europe.<sup id="cite_ref-261" class="reference"><a href="#cite_note-261">[260]</a></sup> There is no official data on the number of <a href="/wiki/Server_(computing)" title="Server (computing)">servers</a> in Google data centers; however, research and advisory firm <a href="/wiki/Gartner" title="Gartner">Gartner</a> estimated in a July 2016 report that Google at the time had 2.5 million servers.<sup id="cite_ref-262" class="reference"><a href="#cite_note-262">[261]</a></sup> Traditionally, Google relied on <a href="/wiki/Parallel_computing" title="Parallel computing">parallel computing</a> on commodity hardware like mainstream x86 computers (similar to home PCs) to keep costs per query low.<sup id="cite_ref-263" class="reference"><a href="#cite_note-263">[262]</a></sup><sup id="cite_ref-264" class="reference"><a href="#cite_note-264">[263]</a></sup><sup id="cite_ref-CNET2009_265-0" class="reference"><a href="#cite_note-CNET2009-265">[264]</a></sup> In 2005, it started developing its own designs, which were only revealed in 2009.<sup id="cite_ref-CNET2009_265-1" class="reference"><a href="#cite_note-CNET2009-265">[264]</a></sup></p>
   <p>Google built its own private <a href="/wiki/Submarine_communications_cable" title="Submarine communications cable">submarine communications cables</a>; the first, named Curie, connects California with <a href="/wiki/Chile" title="Chile">Chile</a> and was completed on November 15, 2019.<sup id="cite_ref-266" class="reference"><a href="#cite_note-266">[265]</a></sup><sup id="cite_ref-267" class="reference"><a href="#cite_note-267">[266]</a></sup> The second fully Google-owned undersea cable, named Dunant, connects the United States with France and is planned to begin operation in 2020.<sup id="cite_ref-268" class="reference"><a href="#cite_note-268">[267]</a></sup> Google's third subsea cable, Equiano, will connect <a href="/wiki/Lisbon" title="Lisbon">Lisbon</a>, Portugal with <a href="/wiki/Lagos" title="Lagos">Lagos</a>, Nigeria and <a href="/wiki/Cape_Town" title="Cape Town">Cape Town</a>, South Africa.<sup id="cite_ref-269" class="reference"><a href="#cite_note-269">[268]</a></sup> The company's fourth cable, named Grace Hopper, connects landing points in New York, US, <a href="/wiki/Bude" title="Bude">Bude</a>, UK and <a href="/wiki/Bilbao" title="Bilbao">Bilbao</a>, Spain, and is expected to become operational in 2022.<sup id="cite_ref-270" class="reference"><a href="#cite_note-270">[269]</a></sup></p>
   <h3><span class="mw-headline" id="Environment">Environment</span></h3>
   <p>In October 2006, the company announced plans to install thousands of <a href="/wiki/Solar_panel" title="Solar panel">solar panels</a> to provide up to 1.6&nbsp;mega<a href="/wiki/Watt" title="Watt">watts</a> of electricity, enough to satisfy approximately 30% of the campus' energy needs.<sup id="cite_ref-solar_271-0" class="reference"><a href="#cite_note-solar-271">[270]</a></sup><sup id="cite_ref-272" class="reference"><a href="#cite_note-272">[271]</a></sup> The system is the largest <a href="/wiki/Rooftop_photovoltaic_power_station" title="Rooftop photovoltaic power station">rooftop photovoltaic power station</a> constructed on a U.S. corporate campus and one of the largest on any corporate site in the world.<sup id="cite_ref-solar_271-1" class="reference"><a href="#cite_note-solar-271">[270]</a></sup> Since 2007,<sup class="plainlinks noexcerpt noprint asof-tag update" style="display:none;"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Google&amp;action=edit">[update]</a></sup> Google has aimed for <a href="/wiki/Carbon_neutrality" title="Carbon neutrality">carbon neutrality</a> in regard to its operations.<sup id="cite_ref-273" class="reference"><a href="#cite_note-273">[272]</a></sup></p>
   <p>Google disclosed in September 2011 that it "continuously uses enough electricity to power 200,000 homes", almost 260 million watts or about a quarter of the output of a nuclear power plant. Total carbon emissions for 2010 were just under 1.5 million metric tons, mostly due to fossil fuels that provide electricity for the data centers. Google said that 25 percent of its energy was supplied by renewable fuels in 2010. An average search uses only 0.3 watt-hours of electricity, so all global searches are only 12.5 million watts or 5% of the total electricity consumption by Google.<sup id="cite_ref-274" class="reference"><a href="#cite_note-274">[273]</a></sup></p>
   <p>In 2010, <a href="/wiki/Google_Energy" class="mw-redirect" title="Google Energy">Google Energy</a> made its first investment in a <a href="/wiki/Renewable_energy" title="Renewable energy">renewable energy</a> project, putting $38.8&nbsp;million into two <a href="/wiki/Wind_farm" title="Wind farm">wind farms</a> in <a href="/wiki/North_Dakota" title="North Dakota">North Dakota</a>. The company announced the two locations will generate 169.5&nbsp;megawatts of power, enough to supply 55,000 homes.<sup id="cite_ref-275" class="reference"><a href="#cite_note-275">[274]</a></sup> In February 2010, the <a href="/wiki/Federal_Energy_Regulatory_Commission" title="Federal Energy Regulatory Commission">Federal Energy Regulatory Commission</a> FERC granted Google an authorization to buy and sell energy at market rates.<sup id="cite_ref-276" class="reference"><a href="#cite_note-276">[275]</a></sup> The corporation exercised this authorization in September 2013 when it announced it would purchase all the electricity produced by the not-yet-built 240-megawatt Happy Hereford wind farm.<sup id="cite_ref-277" class="reference"><a href="#cite_note-277">[276]</a></sup></p>
   <p>In July 2010, Google signed an agreement with an Iowa wind farm to buy 114 megawatts of power for 20 years.<sup id="cite_ref-wind_energy_278-0" class="reference"><a href="#cite_note-wind_energy-278">[277]</a></sup></p>
   <p>In December 2016, Google announced that—starting in 2017—it would purchase enough renewable energy to match 100% of the energy usage of its data centers and offices. The commitment will make Google "the world's largest corporate buyer of renewable power, with commitments reaching 2.6 gigawatts (2,600 megawatts) of wind and solar energy".<sup id="cite_ref-279" class="reference"><a href="#cite_note-279">[278]</a></sup><sup id="cite_ref-280" class="reference"><a href="#cite_note-280">[279]</a></sup><sup id="cite_ref-281" class="reference"><a href="#cite_note-281">[280]</a></sup></p>
   <p>In November 2017, Google bought 536 megawatts of wind power. The purchase made the firm reach <a href="/wiki/100%25_renewable_energy" title="100% renewable energy">100% renewable energy</a>. The wind energy comes from two power plants in South Dakota, one in Iowa and one in Oklahoma.<sup id="cite_ref-282" class="reference"><a href="#cite_note-282">[281]</a></sup> In September 2019, Google's chief executive announced plans for a $2 billion wind and solar investment, the biggest renewable energy deal in corporate history. This will grow their green energy profile by 40%, giving them an extra 1.6 gigawatt of clean energy, the company said.<sup id="cite_ref-283" class="reference"><a href="#cite_note-283">[282]</a></sup></p>
   <p>In September 2020, Google announced it had retroactively offset all of its carbon emissions since the company's foundation in 1998.<sup id="cite_ref-284" class="reference"><a href="#cite_note-284">[283]</a></sup> It also committed to operating its data centers and offices using only carbon-free energy by 2030.<sup id="cite_ref-285" class="reference"><a href="#cite_note-285">[284]</a></sup> In October 2020, the company pledged to make the packaging for its hardware products 100% plastic-free and 100% recyclable by 2025. It also said that all its final assembly manufacturing sites will achieve a <a href="/wiki/UL_(safety_organization)" title="UL (safety organization)">UL</a> 2799 <a href="/wiki/Zero_waste#Corporate_initiatives" title="Zero waste">Zero Waste to Landfill</a> certification by 2022 by ensuring that the vast majority of waste from the manufacturing process is recycled instead of ending up in a landfill.<sup id="cite_ref-286" class="reference"><a href="#cite_note-286">[285]</a></sup></p>
   <p>Google donates to politicians who deny climate change, including <a href="/wiki/Jim_Inhofe" title="Jim Inhofe">Jim Inhofe</a>, and sponsors <a href="/wiki/Climate_change_denial" title="Climate change denial">climate change denial</a> political groups including the <a href="/wiki/State_Policy_Network" title="State Policy Network">State Policy Network</a> and the <a href="/wiki/Competitive_Enterprise_Institute" title="Competitive Enterprise Institute">Competitive Enterprise Institute</a>.<sup id="cite_ref-287" class="reference"><a href="#cite_note-287">[286]</a></sup><sup id="cite_ref-288" class="reference"><a href="#cite_note-288">[287]</a></sup><sup id="cite_ref-289" class="reference"><a href="#cite_note-289">[288]</a></sup></p>
   <h3><span class="mw-headline" id="Philanthropy">Philanthropy</span></h3>
   <div role="note" class="hatnote navigation-not-searchable">Main article: <a href="/wiki/Google.org" title="Google.org">Google.org</a></div>
   <p>In 2004, Google formed the not-for-profit philanthropic <a href="/wiki/Google.org" title="Google.org">Google.org</a>, with a start-up fund of $1&nbsp;billion.<sup id="cite_ref-philanthropy_290-0" class="reference"><a href="#cite_note-philanthropy-290">[289]</a></sup> The mission of the organization is to create <a href="/wiki/Climate_change_education" title="Climate change education">awareness about climate change</a>, global public health, and global poverty. One of its first projects was to develop a viable <a href="/wiki/Plug-in_hybrid" title="Plug-in hybrid">plug-in hybrid</a> <a href="/wiki/Electric_vehicle" title="Electric vehicle">electric vehicle</a> that can attain 100 miles per gallon. Google hired <a href="/wiki/Larry_Brilliant" title="Larry Brilliant">Larry Brilliant</a> as the program's executive director in 2004<sup id="cite_ref-291" class="reference"><a href="#cite_note-291">[290]</a></sup> and Megan Smith has since<sup class="plainlinks noexcerpt noprint asof-tag update" style="display:none;"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Google&amp;action=edit">[update]</a></sup> replaced him as director.<sup id="cite_ref-292" class="reference"><a href="#cite_note-292">[291]</a></sup></p>
   <p>In 2008, Google announced its "project 10<sup>100</sup>" which accepted ideas for how to help the community and then allowed Google users to vote on their favorites.<sup id="cite_ref-293" class="reference"><a href="#cite_note-293">[292]</a></sup> After two years of silence, during which many wondered what had happened to the program,<sup id="cite_ref-294" class="reference"><a href="#cite_note-294">[293]</a></sup> Google revealed the winners of the project, giving a total of ten million dollars to various ideas ranging from non-profit organizations that promote education to a website that intends to make all legal documents public and online.<sup id="cite_ref-295" class="reference"><a href="#cite_note-295">[294]</a></sup></p>
   <p>In March 2007, in partnership with the <a href="/wiki/Mathematical_Sciences_Research_Institute" title="Mathematical Sciences Research Institute">Mathematical Sciences Research Institute</a> (MSRI), Google hosted the first <a href="/wiki/Julia_Robinson_Mathematics_Festival" title="Julia Robinson Mathematics Festival">Julia Robinson Mathematics Festival</a> at its headquarters in Mountain View.<sup id="cite_ref-296" class="reference"><a href="#cite_note-296">[295]</a></sup> In 2011, Google donated 1&nbsp;million euros to <a href="/wiki/International_Mathematical_Olympiad" title="International Mathematical Olympiad">International Mathematical Olympiad</a> to support the next five annual International Mathematical Olympiads (2011–2015).<sup id="cite_ref-297" class="reference"><a href="#cite_note-297">[296]</a></sup><sup id="cite_ref-298" class="reference"><a href="#cite_note-298">[297]</a></sup> In July 2012, Google launched a "<a href="/wiki/Legalize_Love" class="mw-redirect" title="Legalize Love">Legalize Love</a>" campaign in support of <a href="/wiki/Gay_rights" class="mw-redirect" title="Gay rights">gay rights</a>.<sup id="cite_ref-299" class="reference"><a href="#cite_note-299">[298]</a></sup></p>
   <h2><span class="mw-headline" id="Criticism_and_controversies">Criticism and controversies</span></h2>
   <div role="note" class="hatnote navigation-not-searchable">Main articles: <a href="/wiki/Criticism_of_Google" title="Criticism of Google">Criticism of Google</a>, <a href="/wiki/Censorship_by_Google" title="Censorship by Google">Censorship by Google</a>, and <a href="/wiki/Privacy_concerns_regarding_Google" title="Privacy concerns regarding Google">Privacy concerns regarding Google</a></div>
   <table class="box-Summarize plainlinks metadata ambox ambox-style" role="presentation">
      <tbody>
         <tr>
            <td class="mbox-image">
               <div style="width:52px"><img alt="" src="//upload.wikimedia.org/wikipedia/en/thumb/f/f2/Edit-clear.svg/40px-Edit-clear.svg.png" decoding="async" width="40" height="40" srcset="//upload.wikimedia.org/wikipedia/en/thumb/f/f2/Edit-clear.svg/60px-Edit-clear.svg.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/f/f2/Edit-clear.svg/80px-Edit-clear.svg.png 2x" data-file-width="48" data-file-height="48"></div>
            </td>
            <td class="mbox-text">
               <div class="mbox-text-span"><b>This section should include a better summary of <a href="/wiki/Criticism_of_Google" title="Criticism of Google">Criticism of Google</a>.</b><span class="hide-when-compact"> See <a href="/wiki/Wikipedia:Summary_style" title="Wikipedia:Summary style">Wikipedia:Summary style</a> for information on how to properly incorporate it into this article's main text.</span>  <small class="date-container"><i>(<span class="date">April 2019</span>)</i></small></div>
            </td>
         </tr>
      </tbody>
   </table>
   <div class="thumb tright">
      <div class="thumbinner" style="width:222px;">
         <a href="/wiki/File:Google_bus_protest.jpg" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/8/80/Google_bus_protest.jpg/220px-Google_bus_protest.jpg" decoding="async" width="220" height="157" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/8/80/Google_bus_protest.jpg/330px-Google_bus_protest.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/8/80/Google_bus_protest.jpg/440px-Google_bus_protest.jpg 2x" data-file-width="3000" data-file-height="2142"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Google_bus_protest.jpg" class="internal" title="Enlarge"></a></div>
            San Francisco activists <a href="/wiki/San_Francisco_tech_bus_protests" title="San Francisco tech bus protests">protest privately owned shuttle buses</a> that transport workers for tech companies such as Google from their homes in San Francisco and Oakland to corporate campuses in Silicon Valley.
         </div>
      </div>
   </div>
   <p>Google's market dominance has led to prominent media coverage, including <a href="/wiki/Criticism_of_Google" title="Criticism of Google">criticism of Google</a> over issues such as <a href="/wiki/Google_tax_avoidance" class="mw-redirect" title="Google tax avoidance">aggressive tax avoidance</a>,<sup id="cite_ref-300" class="reference"><a href="#cite_note-300">[299]</a></sup> <a href="/wiki/Criticism_of_Google#Page_rank" title="Criticism of Google">search neutrality</a>, <a href="/wiki/Criticism_of_Google#Copyright_issues" title="Criticism of Google">copyright</a>, <a href="/wiki/Censorship_by_Google" title="Censorship by Google">censorship</a> of search results and content,<sup id="cite_ref-301" class="reference"><a href="#cite_note-301">[300]</a></sup> and <a href="/wiki/Google_privacy" class="mw-redirect" title="Google privacy">privacy</a>.<sup id="cite_ref-302" class="reference"><a href="#cite_note-302">[301]</a></sup><sup id="cite_ref-303" class="reference"><a href="#cite_note-303">[302]</a></sup> Other criticisms include alleged misuse and manipulation of search results, its use of others' <a href="/wiki/Intellectual_property" title="Intellectual property">intellectual property</a>, concerns that its <a href="/wiki/Data_collection" title="Data collection">compilation of data</a> may violate people's <a href="/wiki/Internet_privacy" title="Internet privacy">privacy</a>, and the <a href="/wiki/Energy_consumption" title="Energy consumption">energy consumption</a> of its servers, as well as concerns over traditional business issues such as <a href="/wiki/Monopoly" title="Monopoly">monopoly</a>, <a href="/wiki/Restraint_of_trade" title="Restraint of trade">restraint of trade</a>, <a href="/wiki/Anti-competitive_practices" title="Anti-competitive practices">anti-competitive practices</a>, and <a href="/wiki/Patent_infringement" title="Patent infringement">patent infringement</a>.</p>
   <p>Google formerly adhered to the <a href="/wiki/Internet_censorship_in_the_People%27s_Republic_of_China" class="mw-redirect" title="Internet censorship in the People's Republic of China">Internet censorship policies of China</a>,<sup id="cite_ref-304" class="reference"><a href="#cite_note-304">[303]</a></sup> enforced by means of filters colloquially known as "The <a href="/wiki/Great_Firewall_of_China" class="mw-redirect" title="Great Firewall of China">Great Firewall of China</a>", but <a href="/wiki/Censorship_by_Google#China" title="Censorship by Google">no longer does so</a>. As a result, all Google services except for Chinese Google Maps are blocked from access within mainland China without the aid of VPNs, proxy servers, or other similar technologies. <i>The Intercept</i> reported in August 2018 that Google is developing for the People's Republic of China a censored version of its search engine (known as <a href="/wiki/Dragonfly_(search_engine)" title="Dragonfly (search engine)">Dragonfly</a>) "that will blacklist websites and search terms about human rights, democracy, religion, and peaceful protest".<sup id="cite_ref-305" class="reference"><a href="#cite_note-305">[304]</a></sup><sup id="cite_ref-306" class="reference"><a href="#cite_note-306">[305]</a></sup> However, the project had been withheld due to privacy concerns.<sup id="cite_ref-307" class="reference"><a href="#cite_note-307">[306]</a></sup></p>
   <p>Following media reports about <a href="/wiki/PRISM_(surveillance_program)" title="PRISM (surveillance program)">PRISM</a>, NSA's massive electronic <a href="/wiki/Mass_surveillance" title="Mass surveillance">surveillance program</a>, in June 2013, several technology companies were identified as participants, including Google.<sup id="cite_ref-308" class="reference"><a href="#cite_note-308">[307]</a></sup> According to leaks of said program, Google joined the PRISM program in 2009.<sup id="cite_ref-309" class="reference"><a href="#cite_note-309">[308]</a></sup></p>
   <p>Google has worked with the <a href="/wiki/United_States_Department_of_Defense" title="United States Department of Defense">United States Department of Defense</a> on drone software through the 2017 "Project Maven" that could be used to improve the accuracy of <a href="/wiki/Drone_strike" title="Drone strike">drone strikes</a>.<sup id="cite_ref-310" class="reference"><a href="#cite_note-310">[309]</a></sup> Thousands of Google employees, including senior engineers, have signed a letter urging Google CEO <a href="/wiki/Sundar_Pichai" title="Sundar Pichai">Sundar Pichai</a> to end a controversial contract with the Pentagon.<sup id="cite_ref-311" class="reference"><a href="#cite_note-311">[310]</a></sup> In response to the backlash, Google ultimately decided to not renew their DoD contract, set to expire in 2019.<sup id="cite_ref-312" class="reference"><a href="#cite_note-312">[311]</a></sup></p>
   <p>Shona Ghosh, a journalist for <a href="/wiki/Business_Insider" title="Business Insider">Business Insider</a>, noted that an increasing digital <a href="/wiki/Resistance_movement" title="Resistance movement">resistance movement</a> against Google has grown. A major hub for critics of Google in order to organize to abstain from using Google products is the <a href="/wiki/Reddit" title="Reddit">Reddit</a> page for the <a href="/wiki/Subreddit" class="mw-redirect" title="Subreddit">subreddit</a> /r/degoogle.<sup id="cite_ref-313" class="reference"><a href="#cite_note-313">[312]</a></sup> The <a href="/wiki/DeGoogle" title="DeGoogle">DeGoogle</a> movement is a <a href="/wiki/Grassroots_campaign" class="mw-redirect" title="Grassroots campaign">grassroots campaign</a> that has spawned as privacy activists urge users to stop using Google products due to growing privacy concerns regarding the company.</p>
   <p>In July 2018, Mozilla Program Manager Chris Peterson accused Google of intentionally slowing down YouTube performance on Firefox.<sup id="cite_ref-314" class="reference"><a href="#cite_note-314">[313]</a></sup><sup id="cite_ref-315" class="reference"><a href="#cite_note-315">[314]</a></sup></p>
   <p>In April 2019, former <a href="/wiki/Mozilla" title="Mozilla">Mozilla</a> executive Jonathan Nightingale accused Google of intentionally and systematically sabotaging the <a href="/wiki/Firefox" title="Firefox">Firefox</a> browser over the past decade in order to boost adoption of <a href="/wiki/Google_Chrome" title="Google Chrome">Google Chrome</a>.<sup id="cite_ref-316" class="reference"><a href="#cite_note-316">[315]</a></sup></p>
   <p>In November 2019, the Office for Civil Rights of the <a href="/wiki/Department_of_Health_and_Human_Services" class="mw-redirect" title="Department of Health and Human Services">Department of Health and Human Services</a> began investigation into <a href="/wiki/Project_Nightingale" title="Project Nightingale">Project Nightingale</a>, to assess whether the "mass collection of individuals’ medical records" complied with <a href="/wiki/Health_Insurance_Portability_and_Accountability_Act" title="Health Insurance Portability and Accountability Act">HIPAA</a>.<sup id="cite_ref-317" class="reference"><a href="#cite_note-317">[316]</a></sup> According to <i>The Wall Street Journal</i>, Google commenced the project in secret, in 2018, with <a href="/wiki/St._Louis" title="St. Louis">St. Louis</a>-based <a href="/wiki/Healthcare" class="mw-redirect" title="Healthcare">healthcare</a> company <a href="/wiki/Ascension_(company)" title="Ascension (company)">Ascension</a>.<sup id="cite_ref-318" class="reference"><a href="#cite_note-318">[317]</a></sup></p>
   <h3><span id="Anti-trust.2C_privacy.2C_and_other_litigation"></span><span class="mw-headline" id="Anti-trust,_privacy,_and_other_litigation">Anti-trust, privacy, and other litigation</span></h3>
   <div role="note" class="hatnote navigation-not-searchable">Main article: <a href="/wiki/Google_litigation" title="Google litigation">Google litigation</a></div>
   <div class="thumb tright">
      <div class="thumbinner" style="width:222px;">
         <a href="/wiki/File:Belgique_-_Bruxelles_-_Schuman_-_Berlaymont_-_01.jpg" class="image"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Belgique_-_Bruxelles_-_Schuman_-_Berlaymont_-_01.jpg/220px-Belgique_-_Bruxelles_-_Schuman_-_Berlaymont_-_01.jpg" decoding="async" width="220" height="123" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Belgique_-_Bruxelles_-_Schuman_-_Berlaymont_-_01.jpg/330px-Belgique_-_Bruxelles_-_Schuman_-_Berlaymont_-_01.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Belgique_-_Bruxelles_-_Schuman_-_Berlaymont_-_01.jpg/440px-Belgique_-_Bruxelles_-_Schuman_-_Berlaymont_-_01.jpg 2x" data-file-width="5180" data-file-height="2894"></a>  
         <div class="thumbcaption">
            <div class="magnify"><a href="/wiki/File:Belgique_-_Bruxelles_-_Schuman_-_Berlaymont_-_01.jpg" class="internal" title="Enlarge"></a></div>
            The European Commission, which imposed three fines on Google in 2017, 2018 and 2019
         </div>
      </div>
   </div>
   <p>Google has been involved in a number of lawsuits including the <a href="/wiki/High-Tech_Employee_Antitrust_Litigation" title="High-Tech Employee Antitrust Litigation">High-Tech Employee Antitrust Litigation</a> which resulted in Google being one of four companies to pay a $415 million settlement to employees.<sup id="cite_ref-319" class="reference"><a href="#cite_note-319">[318]</a></sup></p>
   <p>On June 27, 2017, the company received a record fine of <a href="/wiki/Euro" title="Euro">€</a>2.42 billion from the <a href="/wiki/European_Union" title="European Union">European Union</a> for "promoting its own shopping comparison service at the top of search results."<sup id="cite_ref-320" class="reference"><a href="#cite_note-320">[319]</a></sup> Commenting on the penalty, <i><a href="/wiki/New_Scientist" title="New Scientist">New Scientist</a></i> magazine said: "The hefty sum – the largest ever doled out by the EU's competition regulators – will sting in the short term, but Google can handle it. <a href="/wiki/Alphabet,_Inc." class="mw-redirect" title="Alphabet, Inc.">Alphabet</a>, Google’s parent company, made a profit of $2.5 billion (€2.2 billion) in the first six weeks of 2017 alone. The real impact of the ruling is that Google must stop using its dominance as a search engine to give itself the edge in another market: online price comparisons." The company disputed the ruling.<sup id="cite_ref-321" class="reference"><a href="#cite_note-321">[320]</a></sup> The hearing at the <a href="/wiki/General_Court_(European_Union)" title="General Court (European Union)">General Court of Luxembourg</a> was scheduled for 2020. The court is going to deliver the ultimate judgment by the end of the year.<sup id="cite_ref-322" class="reference"><a href="#cite_note-322">[321]</a></sup></p>
   <p>On July 18, 2018,<sup id="cite_ref-323" class="reference"><a href="#cite_note-323">[322]</a></sup> the <a href="/wiki/European_Commissioner_for_Competition" title="European Commissioner for Competition">European Commission</a> fined Google €4.34 billion for breaching EU antitrust rules. The abuse of dominant position has been referred to Google's constraint applied on Android device manufacturers and network operators to ensure that traffic on Android devices goes to the Google search engine. On October 9, 2018, Google confirmed<sup id="cite_ref-324" class="reference"><a href="#cite_note-324">[323]</a></sup> that it had appealed the fine to the <a href="/wiki/General_Court_(European_Union)" title="General Court (European Union)">General Court</a> of the European Union.<sup id="cite_ref-325" class="reference"><a href="#cite_note-325">[324]</a></sup></p>
   <p>On October 8, 2018, a class action lawsuit was filed against Google and Alphabet due to "non-public" Google+ account data being exposed as a result of a privacy bug that allowed app developers to gain access to the private information of users. The litigation was settled in July 2020 for $7.5 million with a payout to claimants of at least $5 each, with a maximum of $12 each.<sup id="cite_ref-326" class="reference"><a href="#cite_note-326">[325]</a></sup><sup id="cite_ref-327" class="reference"><a href="#cite_note-327">[326]</a></sup><sup id="cite_ref-328" class="reference"><a href="#cite_note-328">[327]</a></sup></p>
   <p>On January 21, 2019, French data regulator <a href="/wiki/CNIL" class="mw-redirect" title="CNIL">CNIL</a> imposed a record €50 million fine on Google for breaching the European Union's <a href="/wiki/General_Data_Protection_Regulation" title="General Data Protection Regulation">General Data Protection Regulation</a>. The judgment claimed Google had failed to sufficiently inform users of its methods for collecting data to personalize advertising. Google issued a statement saying it was “deeply committed” to transparency and was “studying the decision” before determining its response.<sup id="cite_ref-329" class="reference"><a href="#cite_note-329">[328]</a></sup></p>
   <p>On March 20, 2019, the European Commission imposed a €1.49 billion ($1.69 billion) fine on Google for preventing rivals from being able to “compete and innovate fairly” in the online advertising market.<sup id="cite_ref-330" class="reference"><a href="#cite_note-330">[329]</a></sup> European Union competition commissioner Margrethe Vestager said Google had violated EU antitrust rules by “imposing anti-competitive contractual restrictions on third-party websites” that required them to exclude search results from Google's rivals. Kent Walker, Google's senior vice-president of global affairs, said the company had “already made a wide range of changes to our products to address the Commission’s concerns,” and that "we'll be making further updates to give more visibility to rivals in Europe."<sup id="cite_ref-331" class="reference"><a href="#cite_note-331">[330]</a></sup></p>
   <p>After Congressional hearings in July 2020<sup id="cite_ref-332" class="reference"><a href="#cite_note-332">[331]</a></sup> and a report from the House of Representatives' antitrust subcommittee released in early October,<sup id="cite_ref-333" class="reference"><a href="#cite_note-333">[332]</a></sup> the <a href="/wiki/United_States_Department_of_Justice" title="United States Department of Justice">United States Department of Justice</a> filed an antitrust lawsuit against Google on October 20, 2020, asserting that it has illegally maintained its monopoly position in searching and search advertising.<sup id="cite_ref-334" class="reference"><a href="#cite_note-334">[333]</a></sup><sup id="cite_ref-335" class="reference"><a href="#cite_note-335">[334]</a></sup> The lawsuit included an accusation that Google engaged in anticompetitive behavior by paying Apple between $8 billion and $12 billion to be the default search engine on iPhones.<sup id="cite_ref-336" class="reference"><a href="#cite_note-336">[335]</a></sup> <a href="/wiki/Ken_Paxton" title="Ken Paxton">Ken Paxton</a>, a Texas Attorney General leading the suit, stated that "Google is a trillion-dollar monopoly brazenly abusing its monopolistic power, going so far as to induce senior Facebook executives to agree to a contractual scheme that undermines the heart of [the] competitive process." In part, the suit challenges <a href="/wiki/Alphabet_Inc." title="Alphabet Inc.">Alphabet's</a> capacity to fairly compete with the company in online advertising. No Democratic politicians joined Mr. Paxion in the suit. The majority of the accusations against Google involve their <a href="/wiki/List_of_advertising_technology_companies" title="List of advertising technology companies">ad-tech software</a>, of which Google owns the dominant tool at every link in the chain connecting online publishers and advertisers.<sup id="cite_ref-337" class="reference"><a href="#cite_note-337">[336]</a></sup> Later that month, both <a href="/wiki/Facebook" title="Facebook">Facebook</a> and Alphabet agreed to "cooperate and assist one another" in the face of investigation into their online advertising practices.<sup id="cite_ref-338" class="reference"><a href="#cite_note-338">[337]</a></sup><sup id="cite_ref-339" class="reference"><a href="#cite_note-339">[338]</a></sup></p>
   <h2><span class="mw-headline" id="See_also">See also</span></h2>
   <style data-mw-deduplicate="TemplateStyles:r998391716">.mw-parser-output .div-col{margin-top:0.3em;column-width:30em}.mw-parser-output .div-col-small{font-size:90%}.mw-parser-output .div-col-rules{column-rule:1px solid #aaa}.mw-parser-output .div-col dl,.mw-parser-output .div-col ol,.mw-parser-output .div-col ul{margin-top:0}.mw-parser-output .div-col li,.mw-parser-output .div-col dd{page-break-inside:avoid;break-inside:avoid-column}</style>
   <div class="div-col" style="column-width: 21em;">
      <ul>
         <li><a href="/wiki/Outline_of_Google" title="Outline of Google">Outline of Google</a></li>
         <li><a href="/wiki/History_of_Google" title="History of Google">History of Google</a></li>
         <li><a href="/wiki/List_of_mergers_and_acquisitions_by_Alphabet" title="List of mergers and acquisitions by Alphabet">List of mergers and acquisitions by Alphabet</a></li>
         <li><a href="/wiki/List_of_Google_products" title="List of Google products">List of Google products</a></li>
         <li><a href="/wiki/Google_China" title="Google China">Google China</a></li>
         <li><a href="/wiki/Google_logo" title="Google logo">Google logo</a></li>
         <li><a href="/wiki/Googlization" title="Googlization">Googlization</a></li>
         <li><a href="/wiki/Google.org" title="Google.org">Google.org</a></li>
         <li><a href="/wiki/Google_ATAP" title="Google ATAP">Google ATAP</a></li>
      </ul>
   </div>
   <h2><span class="mw-headline" id="Notes">Notes</span></h2>
   <style data-mw-deduplicate="TemplateStyles:r1011085734">.mw-parser-output .reflist{font-size:90%;margin-bottom:0.5em;list-style-type:decimal}.mw-parser-output .reflist .references{font-size:100%;margin-bottom:0;list-style-type:inherit}.mw-parser-output .reflist-columns-2{column-width:30em}.mw-parser-output .reflist-columns-3{column-width:25em}.mw-parser-output .reflist-columns{margin-top:0.3em}.mw-parser-output .reflist-columns ol{margin-top:0}.mw-parser-output .reflist-columns li{page-break-inside:avoid;break-inside:avoid-column}.mw-parser-output .reflist-upper-alpha{list-style-type:upper-alpha}.mw-parser-output .reflist-upper-roman{list-style-type:upper-roman}.mw-parser-output .reflist-lower-alpha{list-style-type:lower-alpha}.mw-parser-output .reflist-lower-greek{list-style-type:lower-greek}.mw-parser-output .reflist-lower-roman{list-style-type:lower-roman}</style>
   <div class="reflist reflist-lower-alpha">
      <div class="mw-references-wrap">
         <ol class="references">
            <li id="cite_note-5"><span class="mw-cite-backlink"><b><a href="#cite_ref-5" aria-label="Jump up" title="Jump up">^</a></b></span> <span class="reference-text">Google was incorporated on September 4, 1998, however, since 2002, the company has celebrated its anniversaries on various days in September, most frequently on September 27.<sup id="cite_ref-1" class="reference"><a href="#cite_note-1">[1]</a></sup><sup id="cite_ref-2" class="reference"><a href="#cite_note-2">[2]</a></sup><sup id="cite_ref-3" class="reference"><a href="#cite_note-3">[3]</a></sup> The shift in dates reportedly happened to celebrate index-size milestones in tandem with the birthday.<sup id="cite_ref-4" class="reference"><a href="#cite_note-4">[4]</a></sup></span></li>
         </ol>
      </div>
   </div>
   <h2><span class="mw-headline" id="References">References</span></h2>
   <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r1011085734">
   <div class="reflist">
      <div class="mw-references-wrap mw-references-columns">
         <ol class="references">
            <li id="cite_note-1">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-1" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <style data-mw-deduplicate="TemplateStyles:r999302996">.mw-parser-output cite.citation{font-style:inherit}.mw-parser-output .citation q{quotes:"\"""\"""'""'"}.mw-parser-output .id-lock-free a,.mw-parser-output .citation .cs1-lock-free a{background:linear-gradient(transparent,transparent),url("//upload.wikimedia.org/wikipedia/commons/6/65/Lock-green.svg")right 0.1em center/9px no-repeat}.mw-parser-output .id-lock-limited a,.mw-parser-output .id-lock-registration a,.mw-parser-output .citation .cs1-lock-limited a,.mw-parser-output .citation .cs1-lock-registration a{background:linear-gradient(transparent,transparent),url("//upload.wikimedia.org/wikipedia/commons/d/d6/Lock-gray-alt-2.svg")right 0.1em center/9px no-repeat}.mw-parser-output .id-lock-subscription a,.mw-parser-output .citation .cs1-lock-subscription a{background:linear-gradient(transparent,transparent),url("//upload.wikimedia.org/wikipedia/commons/a/aa/Lock-red-alt-2.svg")right 0.1em center/9px no-repeat}.mw-parser-output .cs1-subscription,.mw-parser-output .cs1-registration{color:#555}.mw-parser-output .cs1-subscription span,.mw-parser-output .cs1-registration span{border-bottom:1px dotted;cursor:help}.mw-parser-output .cs1-ws-icon a{background:linear-gradient(transparent,transparent),url("//upload.wikimedia.org/wikipedia/commons/4/4c/Wikisource-logo.svg")right 0.1em center/12px no-repeat}.mw-parser-output code.cs1-code{color:inherit;background:inherit;border:none;padding:inherit}.mw-parser-output .cs1-hidden-error{display:none;font-size:100%}.mw-parser-output .cs1-visible-error{font-size:100%}.mw-parser-output .cs1-maint{display:none;color:#33aa33;margin-left:0.3em}.mw-parser-output .cs1-format{font-size:95%}.mw-parser-output .cs1-kern-left,.mw-parser-output .cs1-kern-wl-left{padding-left:0.2em}.mw-parser-output .cs1-kern-right,.mw-parser-output .cs1-kern-wl-right{padding-right:0.2em}.mw-parser-output .citation .mw-selflink{font-weight:inherit}</style>
                  <cite id="CITEREFFitzpatrick2014" class="citation web cs1">Fitzpatrick, Alex (September 4, 2014). <a rel="nofollow" class="external text" href="https://time.com/3250807/google-anniversary/">"Google Used to Be the Company That Did 'Nothing But Search<span class="cs1-kern-right">'</span>"</a>. <i><a href="/wiki/Time_(magazine)" title="Time (magazine)">Time</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Time&amp;rft.atitle=Google+Used+to+Be+the+Company+That+Did+%27Nothing+But+Search%27&amp;rft.date=2014-09-04&amp;rft.aulast=Fitzpatrick&amp;rft.aufirst=Alex&amp;rft_id=https%3A%2F%2Ftime.com%2F3250807%2Fgoogle-anniversary%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-2">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-2" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFTelegraph_Reporters2019" class="citation web cs1">Telegraph Reporters (September 27, 2019). <a rel="nofollow" class="external text" href="https://www.telegraph.co.uk/technology/2019/09/27/when-is-googles-21st-birthday-doodle/">"When is Google's birthday – and why are people confused?"</a>. <i><a href="/wiki/The_Daily_Telegraph" title="The Daily Telegraph">The Telegraph</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Telegraph&amp;rft.atitle=When+is+Google%27s+birthday+%E2%80%93+and+why+are+people+confused%3F&amp;rft.date=2019-09-27&amp;rft.au=Telegraph+Reporters&amp;rft_id=https%3A%2F%2Fwww.telegraph.co.uk%2Ftechnology%2F2019%2F09%2F27%2Fwhen-is-googles-21st-birthday-doodle%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-3">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-3" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGriffin2019" class="citation web cs1">Griffin, Andrew (September 27, 2019). <a rel="nofollow" class="external text" href="https://www.independent.co.uk/life-style/gadgets-and-tech/google-birthday-surprise-spinner-date-problem-start-company-a7968951.html">"Google birthday: The one big problem with the company's celebratory doodle"</a>. <i><a href="/wiki/The_Independent" title="The Independent">The Independent</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Independent&amp;rft.atitle=Google+birthday%3A+The+one+big+problem+with+the+company%27s+celebratory+doodle&amp;rft.date=2019-09-27&amp;rft.aulast=Griffin&amp;rft.aufirst=Andrew&amp;rft_id=https%3A%2F%2Fwww.independent.co.uk%2Flife-style%2Fgadgets-and-tech%2Fgoogle-birthday-surprise-spinner-date-problem-start-company-a7968951.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-4">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-4" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWray2008" class="citation web cs1">Wray, Richard (September 5, 2008). <a rel="nofollow" class="external text" href="https://www.theguardian.com/business/2008/sep/05/google.mediabusiness">"Happy birthday Google"</a>. <i><a href="/wiki/The_Guardian" title="The Guardian">The Guardian</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Guardian&amp;rft.atitle=Happy+birthday+Google&amp;rft.date=2008-09-05&amp;rft.aulast=Wray&amp;rft.aufirst=Richard&amp;rft_id=https%3A%2F%2Fwww.theguardian.com%2Fbusiness%2F2008%2Fsep%2F05%2Fgoogle.mediabusiness&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-6">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-6" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://careers.google.com/locations/sing/">"Singapore"</a>. <i>Google</i><span class="reference-accessdate">. Retrieved <span class="nowrap">February 9,</span> 2021</span>. <q>As our Asia-Pacific headquarters, our Singapore office plays a pivotal role in our global strategy to reach millions of users around the region.</q></cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Google&amp;rft.atitle=Singapore&amp;rft_id=https%3A%2F%2Fcareers.google.com%2Flocations%2Fsing%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-7">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-7" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/20150116073513/https://www.google.com/intl/en/about/company/">"Company – Google"</a>. January 16, 2015. Archived from <a rel="nofollow" class="external text" href="https://www.google.com/intl/en/about/company/">the original</a> on January 16, 2015<span class="reference-accessdate">. Retrieved <span class="nowrap">September 13,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Company+%E2%80%93+Google&amp;rft.date=2015-01-16&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fintl%2Fen%2Fabout%2Fcompany%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-8">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-8" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFClaburn2008" class="citation web cs1">Claburn, Thomas (September 24, 2008). <a rel="nofollow" class="external text" href="https://www.informationweek.com/applications/google-founded-by-sergey-brin-larry-page-and-hubert-chang!/d/d-id/1072309">"Google Founded By Sergey Brin, Larry Page... And Hubert Chang?!?"</a>. <i><a href="/wiki/InformationWeek" title="InformationWeek">InformationWeek</a></i>. <a href="/wiki/UBM_plc" title="UBM plc">UBM plc</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20110628231125/http://www.informationweek.com/news/internet/google/210603678">Archived</a> from the original on June 28, 2011<span class="reference-accessdate">. Retrieved <span class="nowrap">January 22,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=InformationWeek&amp;rft.atitle=Google+Founded+By+Sergey+Brin%2C+Larry+Page...+And+Hubert+Chang%3F%21%3F&amp;rft.date=2008-09-24&amp;rft.aulast=Claburn&amp;rft.aufirst=Thomas&amp;rft_id=https%3A%2F%2Fwww.informationweek.com%2Fapplications%2Fgoogle-founded-by-sergey-brin-larry-page-and-hubert-chang%21%2Fd%2Fd-id%2F1072309&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-9">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-9" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/about/jobs/locations/">"Locations&nbsp;— Google Jobs"</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20130930200600/http://www.google.com/about/jobs/locations/">Archived</a> from the original on September 30, 2013<span class="reference-accessdate">. Retrieved <span class="nowrap">September 27,</span> 2013</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Locations+%E2%80%94+Google+Jobs&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fabout%2Fjobs%2Flocations%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-:0-10">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-:0_10-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-:0_10-1"><sup><i><b>b</b></i></sup></a> <a href="#cite_ref-:0_10-2"><sup><i><b>c</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWakabayashi2019" class="citation news cs1">Wakabayashi, Daisuke (May 28, 2019). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2019/05/28/technology/google-temp-workers.html">"Google's Shadow Work Force: Temps Who Outnumber Full-Time Employees (Published 2019)"</a>. <i>The New York Times</i>. <a href="/wiki/ISSN_(identifier)" class="mw-redirect" title="ISSN (identifier)">ISSN</a>&nbsp;<a rel="nofollow" class="external text" href="//www.worldcat.org/issn/0362-4331">0362-4331</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20201218055115/https://www.nytimes.com/2019/05/28/technology/google-temp-workers.html">Archived</a> from the original on December 18, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">December 30,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=Google%27s+Shadow+Work+Force%3A+Temps+Who+Outnumber+Full-Time+Employees+%28Published+2019%29&amp;rft.date=2019-05-28&amp;rft.issn=0362-4331&amp;rft.aulast=Wakabayashi&amp;rft.aufirst=Daisuke&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2019%2F05%2F28%2Ftechnology%2Fgoogle-temp-workers.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-11">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-11" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFRivas" class="citation web cs1">Rivas, Teresa. <a rel="nofollow" class="external text" href="http://www.barrons.com/articles/ranking-the-big-four-internet-stocks-google-is-no-1-apple-comes-in-last-1503412102">"Ranking The Big Four Tech Stocks: Google Is No. 1, Apple Comes In Last"</a>. <i>www.barrons.com</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181228082808/https://www.barrons.com/articles/ranking-the-big-four-internet-stocks-google-is-no-1-apple-comes-in-last-1503412102">Archived</a> from the original on December 28, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">December 27,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=www.barrons.com&amp;rft.atitle=Ranking+The+Big+Four+Tech+Stocks%3A+Google+Is+No.+1%2C+Apple+Comes+In+Last&amp;rft.aulast=Rivas&amp;rft.aufirst=Teresa&amp;rft_id=http%3A%2F%2Fwww.barrons.com%2Farticles%2Franking-the-big-four-internet-stocks-google-is-no-1-apple-comes-in-last-1503412102&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-12">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-12" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFRitholtz2017" class="citation web cs1">Ritholtz, Barry (October 31, 2017). <a rel="nofollow" class="external text" href="https://www.bloomberg.com/opinion/articles/2017-10-31/the-big-four-of-technology">"The Big Four of Technology"</a>. <i>Bloomberg</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190626024146/https://www.bloomberg.com/opinion/articles/2017-10-31/the-big-four-of-technology">Archived</a> from the original on June 26, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">December 27,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Bloomberg&amp;rft.atitle=The+Big+Four+of+Technology&amp;rft.date=2017-10-31&amp;rft.aulast=Ritholtz&amp;rft.aufirst=Barry&amp;rft_id=https%3A%2F%2Fwww.bloomberg.com%2Fopinion%2Farticles%2F2017-10-31%2Fthe-big-four-of-technology&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-13">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-13" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://whatis.techtarget.com/definition/GAFA">"What is GAFA (the big four)? - Definition from WhatIs.com"</a>. <i>WhatIs.com</i><span class="reference-accessdate">. Retrieved <span class="nowrap">March 5,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=WhatIs.com&amp;rft.atitle=What+is+GAFA+%28the+big+four%29%3F+-+Definition+from+WhatIs.com&amp;rft_id=https%3A%2F%2Fwhatis.techtarget.com%2Fdefinition%2FGAFA&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-14">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-14" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://businesssearch.sos.ca.gov/Document/RetrievePDF?Id=02474131-5043839">"Business Entity Filing"</a>. <i>Business Search</i>. October 7, 2002. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190814022055/https://businesssearch.sos.ca.gov/Document/RetrievePDF?Id=02474131-5043839">Archived</a> from the original on August 14, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">August 14,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Business+Search&amp;rft.atitle=Business+Entity+Filing&amp;rft.date=2002-10-07&amp;rft_id=https%3A%2F%2Fbusinesssearch.sos.ca.gov%2FDocument%2FRetrievePDF%3FId%3D02474131-5043839&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-15">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-15" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.androidpolice.com/2021/01/04/google-employees-are-forming-a-union/">"Google employees are forming a union"</a>. <i>Android Police</i>. January 4, 2021<span class="reference-accessdate">. Retrieved <span class="nowrap">January 25,</span> 2021</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Android+Police&amp;rft.atitle=Google+employees+are+forming+a+union&amp;rft.date=2021-01-04&amp;rft_id=https%3A%2F%2Fwww.androidpolice.com%2F2021%2F01%2F04%2Fgoogle-employees-are-forming-a-union%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-16">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-16" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFByford2016" class="citation web cs1">Byford, Sam (September 27, 2016). <a rel="nofollow" class="external text" href="https://www.theverge.com/2016/9/27/13070922/google-station-public-wi-fi-india">"Google Station is a new platform that aims to make public Wi-Fi better"</a>. <i>The Verge</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170903210758/https://www.theverge.com/2016/9/27/13070922/google-station-public-wi-fi-india">Archived</a> from the original on September 3, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">May 22,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+Station+is+a+new+platform+that+aims+to+make+public+Wi-Fi+better&amp;rft.date=2016-09-27&amp;rft.aulast=Byford&amp;rft.aufirst=Sam&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2016%2F9%2F27%2F13070922%2Fgoogle-station-public-wi-fi-india&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-topsites-17">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-topsites_17-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.alexa.com/topsites">"The top 500 sites on the web"</a>. <a href="/wiki/Alexa_Internet" title="Alexa Internet">Alexa Internet</a>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=The+top+500+sites+on+the+web&amp;rft.pub=Alexa+Internet&amp;rft_id=https%3A%2F%2Fwww.alexa.com%2Ftopsites&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-18">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-18" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.forbes.com/the-worlds-most-valuable-brands/">"THE WORLD'S VALUABLE BRANDS"</a>. <a href="/wiki/Forbes" title="Forbes">Forbes</a>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=THE+WORLD%27S+VALUABLE+BRANDS&amp;rft.pub=Forbes&amp;rft_id=https%3A%2F%2Fwww.forbes.com%2Fthe-worlds-most-valuable-brands%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-19">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-19" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://interbrand.com/best-global-brands/">"BEST GLOBAL BRANDS"</a>. Interbrand.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=BEST+GLOBAL+BRANDS&amp;rft.pub=Interbrand&amp;rft_id=https%3A%2F%2Finterbrand.com%2Fbest-global-brands%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-milestones-20">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-milestones_20-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-milestones_20-1"><sup><i><b>b</b></i></sup></a> <a href="#cite_ref-milestones_20-2"><sup><i><b>c</b></i></sup></a> <a href="#cite_ref-milestones_20-3"><sup><i><b>d</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/20120401005940/http://www.google.com/about/company/history/">"Our history in depth"</a>. <i>Google Company</i>. Archived from <a rel="nofollow" class="external text" href="https://www.google.com/about/company/history/">the original</a> on April 1, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">July 15,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Google+Company&amp;rft.atitle=Our+history+in+depth&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fabout%2Fcompany%2Fhistory%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-vanityfair-21">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-vanityfair_21-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-vanityfair_21-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFFisher2018" class="citation web cs1">Fisher, Adam (July 10, 2018). <a rel="nofollow" class="external text" href="https://www.vanityfair.com/news/2018/07/valley-of-genius-excerpt-google">"Brin, Page, and Mayer on the Accidental Birth of the Company that Changed Everything"</a>. <i><a href="/wiki/Vanity_Fair_(magazine)" title="Vanity Fair (magazine)">Vanity Fair</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190704184309/https://www.vanityfair.com/news/2018/07/valley-of-genius-excerpt-google">Archived</a> from the original on July 4, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">August 23,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Vanity+Fair&amp;rft.atitle=Brin%2C+Page%2C+and+Mayer+on+the+Accidental+Birth+of+the+Company+that+Changed+Everything&amp;rft.date=2018-07-10&amp;rft.aulast=Fisher&amp;rft.aufirst=Adam&amp;rft_id=https%3A%2F%2Fwww.vanityfair.com%2Fnews%2F2018%2F07%2Fvalley-of-genius-excerpt-google&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-22">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-22" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMcHugh2003" class="citation web cs1">McHugh, Josh (January 1, 2003). <a rel="nofollow" class="external text" href="https://www.wired.com/2003/01/google-10/">"Google vs. Evil"</a>. <i><a href="/wiki/Wired_(magazine)" title="Wired (magazine)">Wired</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190602064540/https://www.wired.com/2003/01/google-10/">Archived</a> from the original on June 2, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">August 24,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Wired&amp;rft.atitle=Google+vs.+Evil&amp;rft.date=2003-01-01&amp;rft.aulast=McHugh&amp;rft.aufirst=Josh&amp;rft_id=https%3A%2F%2Fwww.wired.com%2F2003%2F01%2Fgoogle-10%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-23">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-23" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="https://spectrum.ieee.org/view-from-the-valley/at-work/start-ups/willow-garage-founder-scott-hassan-aims-to-build-a-startup-village">"Willow Garage Founder Scott Hassan Aims To Build A Startup Village"</a>. <i><a href="/wiki/IEEE_Spectrum" title="IEEE Spectrum">IEEE Spectrum</a></i>. September 5, 2014. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190824075356/https://spectrum.ieee.org/view-from-the-valley/at-work/start-ups/willow-garage-founder-scott-hassan-aims-to-build-a-startup-village">Archived</a> from the original on August 24, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">September 1,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=IEEE+Spectrum&amp;rft.atitle=Willow+Garage+Founder+Scott+Hassan+Aims+To+Build+A+Startup+Village&amp;rft.date=2014-09-05&amp;rft_id=https%3A%2F%2Fspectrum.ieee.org%2Fview-from-the-valley%2Fat-work%2Fstart-ups%2Fwillow-garage-founder-scott-hassan-aims-to-build-a-startup-village&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-24">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-24" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFD'Onfro2016" class="citation news cs1">D'Onfro, Jillian (February 13, 2016). <a rel="nofollow" class="external text" href="https://www.businessinsider.com/a-look-back-at-willow-garage-2016-2">"How a billionaire who wrote Google's original code created a robot revolution"</a>. <i><a href="/wiki/Business_Insider" title="Business Insider">Business Insider</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190824075346/https://www.businessinsider.com/a-look-back-at-willow-garage-2016-2">Archived</a> from the original on August 24, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">August 24,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Business+Insider&amp;rft.atitle=How+a+billionaire+who+wrote+Google%27s+original+code+created+a+robot+revolution&amp;rft.date=2016-02-13&amp;rft.aulast=D%27Onfro&amp;rft.aufirst=Jillian&amp;rft_id=https%3A%2F%2Fwww.businessinsider.com%2Fa-look-back-at-willow-garage-2016-2&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-25">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-25" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFPageBrinMotwaniWinograd1999" class="citation web cs1"><a href="/wiki/Larry_Page" title="Larry Page">Page, Lawrence</a>; <a href="/wiki/Sergey_Brin" title="Sergey Brin">Brin, Sergey</a>; Motwani, Rajeev; Winograd, Terry (November 11, 1999). <a rel="nofollow" class="external text" href="http://ilpubs.stanford.edu:8090/422/">"The PageRank Citation Ranking: Bringing Order to the Web"</a>. <i>Stanford University</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20091118014915/http://ilpubs.stanford.edu:8090/422/">Archived</a> from the original on November 18, 2009.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Stanford+University&amp;rft.atitle=The+PageRank+Citation+Ranking%3A+Bringing+Order+to+the+Web&amp;rft.date=1999-11-11&amp;rft.aulast=Page&amp;rft.aufirst=Lawrence&amp;rft.au=Brin%2C+Sergey&amp;rft.au=Motwani%2C+Rajeev&amp;rft.au=Winograd%2C+Terry&amp;rft_id=http%3A%2F%2Filpubs.stanford.edu%3A8090%2F422%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-26">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-26" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://about.google/products/">"Helpful products. For everyone"</a>. <i>Google, Inc</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100210175913/http://www.google.com/corporate/tech.html">Archived</a> from the original on February 10, 2010.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Google%2C+Inc.&amp;rft.atitle=Helpful+products.+For+everyone.&amp;rft_id=https%3A%2F%2Fabout.google%2Fproducts%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-27">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-27" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFPage1997" class="citation web cs1"><a href="/wiki/Larry_Page" title="Larry Page">Page, Larry</a> (August 18, 1997). <a rel="nofollow" class="external text" href="http://ilpubs.stanford.edu:8090/422/">"PageRank: Bringing Order to the Web"</a>. <i>Stanford Digital Library Project</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20020506051802/http://www-diglib.stanford.edu/cgi-bin/WP/get/SIDL-WP-1997-0072?1">Archived</a> from the original on May 6, 2002<span class="reference-accessdate">. Retrieved <span class="nowrap">November 27,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Stanford+Digital+Library+Project&amp;rft.atitle=PageRank%3A+Bringing+Order+to+the+Web&amp;rft.date=1997-08-18&amp;rft.aulast=Page&amp;rft.aufirst=Larry&amp;rft_id=http%3A%2F%2Filpubs.stanford.edu%3A8090%2F422%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-28">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-28" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBattelle2005" class="citation news cs1">Battelle, John (August 2005). <a rel="nofollow" class="external text" href="https://www.wired.com/wired/archive/13.08/battelle.html?tw=wn_tophead_4">"The Birth of Google"</a>. <i>Wired</i>. <a rel="nofollow" class="external text" href="https://www.webcitation.org/6BYbTgdmC?url=http://www.wired.com/wired/archive/13.08/battelle.html?tw=wn_tophead_4">Archived</a> from the original on October 20, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">October 12,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Wired&amp;rft.atitle=The+Birth+of+Google&amp;rft.date=2005-08&amp;rft.aulast=Battelle&amp;rft.aufirst=John&amp;rft_id=https%3A%2F%2Fwww.wired.com%2Fwired%2Farchive%2F13.08%2Fbattelle.html%3Ftw%3Dwn_tophead_4&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-29">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-29" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFTrex2009" class="citation web cs1">Trex, Ethan (February 17, 2009). <a rel="nofollow" class="external text" href="https://www.mentalfloss.com/article/20890/9-people-places-things-changed-their-names">"9 People, Places &amp; Things That Changed Their Names"</a>. <i><a href="/wiki/Mental_Floss" title="Mental Floss">Mental Floss</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20140810100639/http://mentalfloss.com/article/20890/9-people-places-things-changed-their-names">Archived</a> from the original on August 10, 2014.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Mental+Floss&amp;rft.atitle=9+People%2C+Places+%26+Things+That+Changed+Their+Names&amp;rft.date=2009-02-17&amp;rft.aulast=Trex&amp;rft.aufirst=Ethan&amp;rft_id=https%3A%2F%2Fwww.mentalfloss.com%2Farticle%2F20890%2F9-people-places-things-changed-their-names&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-30">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-30" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/19961224105215/http://huron.stanford.edu/">"Backrub search engine at Stanford University"</a>. Archived from <a rel="nofollow" class="external text" href="http://huron.stanford.edu">the original</a> on December 24, 1996<span class="reference-accessdate">. Retrieved <span class="nowrap">March 12,</span> 2011</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Backrub+search+engine+at+Stanford+University&amp;rft_id=http%3A%2F%2Fhuron.stanford.edu&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-originalpaper-31">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-originalpaper_31-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-originalpaper_31-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBrinPage1998" class="citation journal cs1"><a href="/wiki/Sergey_Brin" title="Sergey Brin">Brin, Sergey</a>; <a href="/wiki/Larry_Page" title="Larry Page">Page, Lawrence</a> (1998). <a rel="nofollow" class="external text" href="http://infolab.stanford.edu/pub/papers/google.pdf">"The anatomy of a large-scale hypertextual Web search engine"</a> <span class="cs1-format">(PDF)</span>. <i>Computer Networks and ISDN Systems</i>. <b>30</b> (1–7): 107–117. <a href="/wiki/CiteSeerX_(identifier)" class="mw-redirect" title="CiteSeerX (identifier)">CiteSeerX</a>&nbsp;<span class="cs1-lock-free" title="Freely accessible"><a rel="nofollow" class="external text" href="//citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.115.5930">10.1.1.115.5930</a></span>. <a href="/wiki/Doi_(identifier)" class="mw-redirect" title="Doi (identifier)">doi</a>:<a rel="nofollow" class="external text" href="https://doi.org/10.1016%2FS0169-7552%2898%2900110-X">10.1016/S0169-7552(98)00110-X</a>. <a href="/wiki/ISSN_(identifier)" class="mw-redirect" title="ISSN (identifier)">ISSN</a>&nbsp;<a rel="nofollow" class="external text" href="//www.worldcat.org/issn/0169-7552">0169-7552</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20150927004511/http://infolab.stanford.edu/pub/papers/google.pdf">Archived</a> <span class="cs1-format">(PDF)</span> from the original on September 27, 2015<span class="reference-accessdate">. Retrieved <span class="nowrap">April 7,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Computer+Networks+and+ISDN+Systems&amp;rft.atitle=The+anatomy+of+a+large-scale+hypertextual+Web+search+engine&amp;rft.volume=30&amp;rft.issue=1%E2%80%937&amp;rft.pages=107-117&amp;rft.date=1998&amp;rft_id=%2F%2Fciteseerx.ist.psu.edu%2Fviewdoc%2Fsummary%3Fdoi%3D10.1.1.115.5930%23id-name%3DCiteSeerX&amp;rft.issn=0169-7552&amp;rft_id=info%3Adoi%2F10.1016%2FS0169-7552%2898%2900110-X&amp;rft.aulast=Brin&amp;rft.aufirst=Sergey&amp;rft.au=Page%2C+Lawrence&amp;rft_id=http%3A%2F%2Finfolab.stanford.edu%2Fpub%2Fpapers%2Fgoogle.pdf&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-32"><span class="mw-cite-backlink"><b><a href="#cite_ref-32" aria-label="Jump up" title="Jump up">^</a></b></span> <span class="reference-text"><a rel="nofollow" class="external text" href="http://www.rankdex.com/about.html">"About: RankDex"</a> <a rel="nofollow" class="external text" href="https://www.webcitation.org/659XSbLCF?url=http://www.rankdex.com/about.html">Archived</a> February 2, 2012, at <a href="/wiki/WebCite" title="WebCite">WebCite</a>, <i><a href="/wiki/RankDex" class="mw-redirect" title="RankDex">RankDex</a></i></span></li>
            <li id="cite_note-33">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-33" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFAltucher2011" class="citation web cs1">Altucher, James (March 18, 2011). <a rel="nofollow" class="external text" href="https://www.forbes.com/sites/jamesaltucher/2011/03/18/10-unusual-things-about-google-also-the-worst-vc-decision-i-ever-made/">"10 Unusual Things About Google"</a>. <i><a href="/wiki/Forbes" title="Forbes">Forbes</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190616133656/https://www.forbes.com/sites/jamesaltucher/2011/03/18/10-unusual-things-about-google-also-the-worst-vc-decision-i-ever-made/">Archived</a> from the original on June 16, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">June 16,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Forbes&amp;rft.atitle=10+Unusual+Things+About+Google&amp;rft.date=2011-03-18&amp;rft.aulast=Altucher&amp;rft.aufirst=James&amp;rft_id=https%3A%2F%2Fwww.forbes.com%2Fsites%2Fjamesaltucher%2F2011%2F03%2F18%2F10-unusual-things-about-google-also-the-worst-vc-decision-i-ever-made%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-34">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-34" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/patents/US6285999">"Method for node ranking in a linked database"</a>. Google Patents. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20151015185034/http://www.google.com/patents/US6285999">Archived</a> from the original on October 15, 2015<span class="reference-accessdate">. Retrieved <span class="nowrap">October 19,</span> 2015</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Method+for+node+ranking+in+a+linked+database&amp;rft.pub=Google+Patents&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fpatents%2FUS6285999&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-35">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-35" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKoller2004" class="citation web cs1">Koller, David (January 2004). <a rel="nofollow" class="external text" href="http://graphics.stanford.edu/~dk/google_name_origin.html">"Origin of the name "Google<span class="cs1-kern-right">"</span>"</a>. <i>Stanford University</i>. <a rel="nofollow" class="external text" href="https://www.webcitation.org/68ubHzYs7?url=http://graphics.stanford.edu/~dk/google_name_origin.html">Archived</a> from the original on July 4, 2012.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Stanford+University&amp;rft.atitle=Origin+of+the+name+%22Google%22&amp;rft.date=2004-01&amp;rft.aulast=Koller&amp;rft.aufirst=David&amp;rft_id=http%3A%2F%2Fgraphics.stanford.edu%2F~dk%2Fgoogle_name_origin.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-36">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-36" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHanley2003" class="citation news cs1">Hanley, Rachael (February 12, 2003). <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100327141327/http://www.stanforddaily.com/2003/02/12/from-googol-to-google">"From Googol to Google"</a>. <i>The Stanford Daily</i>. Stanford University. Archived from <a rel="nofollow" class="external text" href="http://www.stanforddaily.com/2003/02/12/from-googol-to-google">the original</a> on March 27, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">February 15,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Stanford+Daily&amp;rft.atitle=From+Googol+to+Google&amp;rft.date=2003-02-12&amp;rft.aulast=Hanley&amp;rft.aufirst=Rachael&amp;rft_id=http%3A%2F%2Fwww.stanforddaily.com%2F2003%2F02%2F12%2Ffrom-googol-to-google&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-37">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-37" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/19990221202430/https://www.google.com/company.html">"Google! Beta website"</a>. <i>Google, Inc</i>. Archived from <a rel="nofollow" class="external text" href="https://www.google.com/company.html">the original</a> on February 21, 1999<span class="reference-accessdate">. Retrieved <span class="nowrap">October 12,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Google%2C+Inc.&amp;rft.atitle=Google%21+Beta+website&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fcompany.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-38">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-38" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWilliamson2005" class="citation web cs1">Williamson, Alan (January 12, 2005). <a rel="nofollow" class="external text" href="https://www.webcitation.org/61rJXKAeq?url=http://alan.blog-city.com/an_evening_with_googles_marissa_mayer.htm">"An evening with Google's Marissa Mayer"</a>. <i>Alan Williamson</i>. Archived from <a rel="nofollow" class="external text" href="http://alan.blog-city.com/an_evening_with_googles_marissa_mayer.htm">the original</a> on September 21, 2011<span class="reference-accessdate">. Retrieved <span class="nowrap">July 5,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Alan+Williamson&amp;rft.atitle=An+evening+with+Google%27s+Marissa+Mayer&amp;rft.date=2005-01-12&amp;rft.aulast=Williamson&amp;rft.aufirst=Alan&amp;rft_id=http%3A%2F%2Falan.blog-city.com%2Fan_evening_with_googles_marissa_mayer.htm&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-39">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-39" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://whois.domaintools.com/google.com">"Google.com WHOIS, DNS, &amp; Domain Info - DomainTools"</a>. <i><a href="/wiki/WHOIS" title="WHOIS">WHOIS</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20160314084453/http://whois.domaintools.com/google.com">Archived</a> from the original on March 14, 2016.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=WHOIS&amp;rft.atitle=Google.com+WHOIS%2C+DNS%2C+%26+Domain+Info+-+DomainTools&amp;rft_id=https%3A%2F%2Fwhois.domaintools.com%2Fgoogle.com&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-40">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-40" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/19991002122809/http://www-cs-students.stanford.edu/~csilvers/">"Craig Silverstein's website"</a>. <i>Stanford University</i>. Archived from <a rel="nofollow" class="external text" href="http://www-cs-students.stanford.edu/~csilvers/">the original</a> on October 2, 1999<span class="reference-accessdate">. Retrieved <span class="nowrap">October 12,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Stanford+University&amp;rft.atitle=Craig+Silverstein%27s+website&amp;rft_id=http%3A%2F%2Fwww-cs-students.stanford.edu%2F~csilvers%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-41">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-41" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKopytoff2008" class="citation news cs1">Kopytoff, Verne (September 7, 2008). <a rel="nofollow" class="external text" href="https://www.sfgate.com/news/article/Craig-Silverstein-grew-a-decade-with-Google-3270079.php">"Craig Silverstein grew a decade with Google"</a>. <i><a href="/wiki/San_Francisco_Chronicle" title="San Francisco Chronicle">San Francisco Chronicle</a></i>. Hearst Communications, Inc. <a rel="nofollow" class="external text" href="https://www.webcitation.org/6BYbUJWuY?url=http://www.sfgate.com/news/article/Craig-Silverstein-grew-a-decade-with-Google-3270079.php">Archived</a> from the original on October 20, 2012.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=San+Francisco+Chronicle&amp;rft.atitle=Craig+Silverstein+grew+a+decade+with+Google&amp;rft.date=2008-09-07&amp;rft.aulast=Kopytoff&amp;rft.aufirst=Verne&amp;rft_id=https%3A%2F%2Fwww.sfgate.com%2Fnews%2Farticle%2FCraig-Silverstein-grew-a-decade-with-Google-3270079.php&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-42">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-42" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLong2007" class="citation news cs1">Long, Tony (September 7, 2007). <span class="cs1-lock-limited" title="Free access subject to limited trial, subscription normally required"><a rel="nofollow" class="external text" href="https://www.wired.com/2007/09/dayintech-0907/">"Sept. 7, 1998: If the Check Says 'Google Inc.,' We're 'Google Inc.<span class="cs1-kern-right">'</span>"</a></span>. <i><a href="/wiki/Wired_(magazine)" title="Wired (magazine)">Wired</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Wired&amp;rft.atitle=Sept.+7%2C+1998%3A+If+the+Check+Says+%27Google+Inc.%2C%27+We%27re+%27Google+Inc.%27&amp;rft.date=2007-09-07&amp;rft.aulast=Long&amp;rft.aufirst=Tony&amp;rft_id=https%3A%2F%2Fwww.wired.com%2F2007%2F09%2Fdayintech-0907%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-Bechtolsheim-43">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-Bechtolsheim_43-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-Bechtolsheim_43-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKopytoff2004" class="citation news cs1">Kopytoff, Verne (April 29, 2004). <a rel="nofollow" class="external text" href="https://www.sfgate.com/news/article/For-early-Googlers-key-word-is-Founders-2786378.php">"For early Googlers, key word is $"</a>. <i><a href="/wiki/San_Francisco_Chronicle" title="San Francisco Chronicle">San Francisco Chronicle</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20090919030812/http://www.sfgate.com/cgi-bin/article.cgi?file=%2Fchronicle%2Farchive%2F2004%2F04%2F29%2FMNGLD6CFND34.DTL">Archived</a> from the original on September 19, 2009.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=San+Francisco+Chronicle&amp;rft.atitle=For+early+Googlers%2C+key+word+is+%24&amp;rft.date=2004-04-29&amp;rft.aulast=Kopytoff&amp;rft.aufirst=Verne&amp;rft_id=https%3A%2F%2Fwww.sfgate.com%2Fnews%2Farticle%2FFor-early-Googlers-key-word-is-Founders-2786378.php&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-endofworld-44">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-endofworld_44-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-endofworld_44-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFAuletta2010" class="citation book cs1"><a href="/wiki/Ken_Auletta" title="Ken Auletta">Auletta, Ken</a> (2010). <i>Googled: The End of the World as We Know it</i> (Reprint&nbsp;ed.). New York, N.Y.: Penguin Books. <a href="/wiki/ISBN_(identifier)" class="mw-redirect" title="ISBN (identifier)">ISBN</a>&nbsp;<a href="/wiki/Special:BookSources/9780143118046" title="Special:BookSources/9780143118046"><bdi>9780143118046</bdi></a>. <a href="/wiki/OCLC_(identifier)" class="mw-redirect" title="OCLC (identifier)">OCLC</a>&nbsp;<a rel="nofollow" class="external text" href="//www.worldcat.org/oclc/515456623">515456623</a>. <q>On September 7, 1998, the day Google officially incorporated, he [Shriram] wrote out a check for just over $250,000, one of four of this size the founders received.</q></cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=book&amp;rft.btitle=Googled%3A+The+End+of+the+World+as+We+Know+it&amp;rft.place=New+York%2C+N.Y.&amp;rft.edition=Reprint&amp;rft.pub=Penguin+Books&amp;rft.date=2010&amp;rft_id=info%3Aoclcnum%2F515456623&amp;rft.isbn=9780143118046&amp;rft.aulast=Auletta&amp;rft.aufirst=Ken&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-45">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-45" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHoschHall" class="citation web cs1">Hosch, William L.; Hall, Mark. <a rel="nofollow" class="external text" href="https://www.britannica.com/topic/Google-Inc">"Google Inc"</a>. <i>Britannica</i>. Britannica. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190220013941/https://www.britannica.com/topic/Google-Inc">Archived</a> from the original on February 20, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">March 17,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Britannica&amp;rft.atitle=Google+Inc.&amp;rft.aulast=Hosch&amp;rft.aufirst=William+L.&amp;rft.au=Hall%2C+Mark&amp;rft_id=https%3A%2F%2Fwww.britannica.com%2Ftopic%2FGoogle-Inc&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-46">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-46" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation pressrelease cs1"><a rel="nofollow" class="external text" href="https://www.google.com/pressrel/pressrelease1.html">"Google Receives $25&nbsp;Million in Equity Funding"</a> (Press release). Palo Alto, Calif. June 7, 1999. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20010212052759/http://www.google.com/pressrel/pressrelease1.html">Archived</a> from the original on February 12, 2001<span class="reference-accessdate">. Retrieved <span class="nowrap">February 16,</span> 2009</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google+Receives+%2425+Million+in+Equity+Funding&amp;rft.place=Palo+Alto%2C+Calif.&amp;rft.date=1999-06-07&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fpressrel%2Fpressrelease1.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-47">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-47" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWeinberger2015" class="citation web cs1">Weinberger, Matt (October 12, 2015). <a rel="nofollow" class="external text" href="https://www.businessinsider.com/google-history-in-photos-2015-10">"Google's cofounders are stepping down from their company. Here are 43 photos showing Google's rise from a Stanford dorm room to global internet superpower"</a>. <i><a href="/wiki/Business_Insider" title="Business Insider">Business Insider</a></i>. <a href="/wiki/Axel_Springer_SE" title="Axel Springer SE">Axel Springer SE</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170819101107/http://www.businessinsider.com/google-history-in-photos-2015-10">Archived</a> from the original on August 19, 2017.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Business+Insider&amp;rft.atitle=Google%27s+cofounders+are+stepping+down+from+their+company.+Here+are+43+photos+showing+Google%27s+rise+from+a+Stanford+dorm+room+to+global+internet+superpower&amp;rft.date=2015-10-12&amp;rft.aulast=Weinberger&amp;rft.aufirst=Matt&amp;rft_id=https%3A%2F%2Fwww.businessinsider.com%2Fgoogle-history-in-photos-2015-10&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-48">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-48" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.cnet.com/news/a-building-blessed-with-tech-success/">"A building blessed with tech success"</a>. <i><a href="/wiki/CNET" title="CNET">CNET</a></i>. <a href="/wiki/CBS_Interactive" class="mw-redirect" title="CBS Interactive">CBS Interactive</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170523115134/https://www.cnet.com/news/a-building-blessed-with-tech-success/">Archived</a> from the original on May 23, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">July 15,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=CNET&amp;rft.atitle=A+building+blessed+with+tech+success&amp;rft_id=https%3A%2F%2Fwww.cnet.com%2Fnews%2Fa-building-blessed-with-tech-success%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-49">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-49" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFStross2008" class="citation book cs1">Stross, Randall (September 2008). <a rel="nofollow" class="external text" href="https://books.google.com/books?id=xOk3EIUW9VgC">"Introduction"</a>. <a rel="nofollow" class="external text" href="https://books.google.com/books?id=xOk3EIUW9VgC"><i>Planet Google: One Company's Audacious Plan to Organize Everything We Know</i></a>. New York: Free Press. pp.&nbsp;3–4. <a href="/wiki/ISBN_(identifier)" class="mw-redirect" title="ISBN (identifier)">ISBN</a>&nbsp;<a href="/wiki/Special:BookSources/978-1-4165-4691-7" title="Special:BookSources/978-1-4165-4691-7"><bdi>978-1-4165-4691-7</bdi></a><span class="reference-accessdate">. Retrieved <span class="nowrap">February 14,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=bookitem&amp;rft.atitle=Introduction&amp;rft.btitle=Planet+Google%3A+One+Company%27s+Audacious+Plan+to+Organize+Everything+We+Know&amp;rft.place=New+York&amp;rft.pages=3-4&amp;rft.pub=Free+Press&amp;rft.date=2008-09&amp;rft.isbn=978-1-4165-4691-7&amp;rft.aulast=Stross&amp;rft.aufirst=Randall&amp;rft_id=https%3A%2F%2Fbooks.google.com%2Fbooks%3Fid%3DxOk3EIUW9VgC&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-50">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-50" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/20120401005413/http://www.google.com/press/pressrel/pressrelease39.html">"Google Launches Self-Service Advertising Program"</a>. <i>News from Google</i>. October 23, 2000. Archived from <a rel="nofollow" class="external text" href="https://www.google.com/press/pressrel/pressrelease39.html">the original</a> on April 1, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">July 15,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=News+from+Google&amp;rft.atitle=Google+Launches+Self-Service+Advertising+Program&amp;rft.date=2000-10-23&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fpress%2Fpressrel%2Fpressrelease39.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-51">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-51" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFNaughton2000" class="citation news cs1">Naughton, John (July 2, 2000). <a rel="nofollow" class="external text" href="https://www.theguardian.com/technology/2000/jul/02/searchengines.columnists">"Why's Yahoo gone to Google? Search me"</a>. <i>The Guardian</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190131040317/https://www.theguardian.com/technology/2000/jul/02/searchengines.columnists">Archived</a> from the original on January 31, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">January 30,</span> 2019</span> – via www.theguardian.com.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Guardian&amp;rft.atitle=Why%27s+Yahoo+gone+to+Google%3F+Search+me&amp;rft.date=2000-07-02&amp;rft.aulast=Naughton&amp;rft.aufirst=John&amp;rft_id=https%3A%2F%2Fwww.theguardian.com%2Ftechnology%2F2000%2Fjul%2F02%2Fsearchengines.columnists&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-52">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-52" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://googlepress.blogspot.com/2000/06/yahoo-selects-google-as-its-default.html">"Yahoo! Selects Google as its Default Search Engine Provider – News announcements – News from Google – Google"</a>. <i>googlepress.blogspot.com</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190131041155/https://googlepress.blogspot.com/2000/06/yahoo-selects-google-as-its-default.html">Archived</a> from the original on January 31, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">January 30,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=googlepress.blogspot.com&amp;rft.atitle=Yahoo%21+Selects+Google+as+its+Default+Search+Engine+Provider+%E2%80%93+News+announcements+%E2%80%93+News+from+Google+%E2%80%93+Google&amp;rft_id=https%3A%2F%2Fgooglepress.blogspot.com%2F2000%2F06%2Fyahoo-selects-google-as-its-default.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-53">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-53" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://www.computerhistory.org/collections/accession/102662167">"Google Server Assembly"</a>. <i>Computer History Museum</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100722083804/http://www.computerhistory.org/collections/accession/102662167">Archived</a> from the original on July 22, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">July 4,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Computer+History+Museum&amp;rft.atitle=Google+Server+Assembly&amp;rft_id=http%3A%2F%2Fwww.computerhistory.org%2Fcollections%2Faccession%2F102662167&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-sgibldg-54">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-sgibldg_54-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFOlsen2003" class="citation news cs1">Olsen, Stephanie (July 11, 2003). <a rel="nofollow" class="external text" href="http://news.cnet.com/Googles-movin-on-up/2110-1032_3-1025111.html">"Google's movin' on up"</a>. <i><a href="/wiki/CNET" title="CNET">CNET</a></i>. <a href="/wiki/CBS_Interactive" class="mw-redirect" title="CBS Interactive">CBS Interactive</a>. <a rel="nofollow" class="external text" href="https://www.webcitation.org/6BYbYuLmq?url=http://news.cnet.com/Googles-movin-on-up/2110-1032_3-1025111.html">Archived</a> from the original on October 20, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">February 15,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=CNET&amp;rft.atitle=Google%27s+movin%27+on+up&amp;rft.date=2003-07-11&amp;rft.aulast=Olsen&amp;rft.aufirst=Stephanie&amp;rft_id=http%3A%2F%2Fnews.cnet.com%2FGoogles-movin-on-up%2F2110-1032_3-1025111.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-googleplexpurchase-55">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-googleplexpurchase_55-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="https://www.bizjournals.com/sanjose/stories/2006/06/19/newscolumn3.html">"Google to buy headquarters building from Silicon Graphics"</a>. <i><a href="/wiki/American_City_Business_Journals" title="American City Business Journals">American City Business Journals</a></i>. June 16, 2006. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100418071152/http://sanjose.bizjournals.com/sanjose/stories/2006/06/19/newscolumn3.html">Archived</a> from the original on April 18, 2010.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=American+City+Business+Journals&amp;rft.atitle=Google+to+buy+headquarters+building+from+Silicon+Graphics&amp;rft.date=2006-06-16&amp;rft_id=https%3A%2F%2Fwww.bizjournals.com%2Fsanjose%2Fstories%2F2006%2F06%2F19%2Fnewscolumn3.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-56">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-56" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKrantz2006" class="citation web cs1">Krantz, Michael (October 25, 2006). <a rel="nofollow" class="external text" href="http://googleblog.blogspot.com/2006/10/do-you-google.html">"Do You "Google"?"</a>. <i>Google, Inc</i>. <a rel="nofollow" class="external text" href="https://archive.today/20120530/http://googleblog.blogspot.com/2006/10/do-you-google.html">Archived</a> from the original on May 30, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">February 17,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Google%2C+Inc.&amp;rft.atitle=Do+You+%22Google%22%3F&amp;rft.date=2006-10-25&amp;rft.aulast=Krantz&amp;rft.aufirst=Michael&amp;rft_id=http%3A%2F%2Fgoogleblog.blogspot.com%2F2006%2F10%2Fdo-you-google.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-57">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-57" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBylund2006" class="citation web cs1">Bylund, Anders (July 5, 2006). <a rel="nofollow" class="external text" href="https://archive.today/20060707062623/http://msnbc.msn.com/id/13720643/">"To Google or Not to Google"</a>. <i>msnbc.com</i>. Archived from <a rel="nofollow" class="external text" href="http://msnbc.msn.com/id/13720643/">the original</a> on July 7, 2006<span class="reference-accessdate">. Retrieved <span class="nowrap">February 17,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=msnbc.com&amp;rft.atitle=To+Google+or+Not+to+Google&amp;rft.date=2006-07-05&amp;rft.aulast=Bylund&amp;rft.aufirst=Anders&amp;rft_id=http%3A%2F%2Fmsnbc.msn.com%2Fid%2F13720643%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-Google_Inc-58">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-Google_Inc_58-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-Google_Inc_58-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHoschHall" class="citation web cs1">Hosch, William L.; Hall, Mark. <a rel="nofollow" class="external text" href="https://www.britannica.com/topic/Google-Inc">"Google Inc"</a>. <i>Britannica</i>. Britannica. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190220013941/https://www.britannica.com/topic/Google-Inc">Archived</a> from the original on February 20, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">March 17,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Britannica&amp;rft.atitle=Google+Inc.&amp;rft.aulast=Hosch&amp;rft.aufirst=William+L.&amp;rft.au=Hall%2C+Mark&amp;rft_id=https%3A%2F%2Fwww.britannica.com%2Ftopic%2FGoogle-Inc&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-59">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-59" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLashinsky2008" class="citation news cs1">Lashinsky, Adam (January 29, 2008). <a rel="nofollow" class="external text" href="https://money.cnn.com/2008/01/18/news/companies/google.fortune/index.htm">"Google wins again"</a>. <i>Fortune</i>. Time Warner. <a rel="nofollow" class="external text" href="https://www.webcitation.org/6BYbNOfxM?url=http://money.cnn.com/2008/01/18/news/companies/google.fortune/index.htm">Archived</a> from the original on October 20, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">January 22,</span> 2011</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Fortune&amp;rft.atitle=Google+wins+again&amp;rft.date=2008-01-29&amp;rft.aulast=Lashinsky&amp;rft.aufirst=Adam&amp;rft_id=https%3A%2F%2Fmoney.cnn.com%2F2008%2F01%2F18%2Fnews%2Fcompanies%2Fgoogle.fortune%2Findex.htm&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-IPO-60">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-IPO_60-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-IPO_60-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://markets.businessinsider.com/stocks/goog-stock">"GOOG Stock"</a>. <a href="/wiki/Business_Insider" title="Business Insider">Business Insider</a>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=GOOG+Stock&amp;rft.pub=Business+Insider&amp;rft_id=https%3A%2F%2Fmarkets.businessinsider.com%2Fstocks%2Fgoog-stock&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-:1-61">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-:1_61-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-:1_61-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://investor.google.com/pdf/2004_AnnualReport.pdf">"2004 Annual Report"</a> <span class="cs1-format">(PDF)</span>. <i>Google, Inc</i>. Mountain View, California. 2004. p.&nbsp;29. <a rel="nofollow" class="external text" href="https://www.webcitation.org/659XUbJTj?url=http://investor.google.com/pdf/2004_AnnualReport.pdf">Archived</a> <span class="cs1-format">(PDF)</span> from the original on February 2, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">February 19,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Google%2C+Inc.&amp;rft.atitle=2004+Annual+Report&amp;rft.pages=29&amp;rft.date=2004&amp;rft_id=http%3A%2F%2Finvestor.google.com%2Fpdf%2F2004_AnnualReport.pdf&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-62">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-62" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLa_Monica2004" class="citation news cs1">La Monica, Paul R. (April 30, 2004). <a rel="nofollow" class="external text" href="https://money.cnn.com/2004/04/29/technology/google/">"Google sets $2.7&nbsp;billion IPO"</a>. <i>CNN Money</i>. <a rel="nofollow" class="external text" href="https://www.webcitation.org/6BYbWCwIQ?url=http://money.cnn.com/2004/04/29/technology/google/">Archived</a> from the original on October 20, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">February 19,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=CNN+Money&amp;rft.atitle=Google+sets+%242.7+billion+IPO&amp;rft.date=2004-04-30&amp;rft.aulast=La+Monica&amp;rft.aufirst=Paul+R.&amp;rft_id=https%3A%2F%2Fmoney.cnn.com%2F2004%2F04%2F29%2Ftechnology%2Fgoogle%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-63">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-63" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKawamoto2004" class="citation web cs1">Kawamoto, Dawn (April 29, 2004). <a rel="nofollow" class="external text" href="https://www.zdnet.com/news/want-in-on-googles-ipo/135799">"Want In on Google's IPO?"</a>. <i>ZDNet</i>. <a rel="nofollow" class="external text" href="https://www.webcitation.org/659XV2yME?url=http://www.zdnet.com/news/want-in-on-googles-ipo/135799">Archived</a> from the original on February 2, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">February 19,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=ZDNet&amp;rft.atitle=Want+In+on+Google%27s+IPO%3F&amp;rft.date=2004-04-29&amp;rft.aulast=Kawamoto&amp;rft.aufirst=Dawn&amp;rft_id=http%3A%2F%2Fwww.zdnet.com%2Fnews%2Fwant-in-on-googles-ipo%2F135799&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-washpost-64">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-washpost_64-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-washpost_64-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWebb2004" class="citation news cs1">Webb, Cynthia L. (August 19, 2004). <a rel="nofollow" class="external text" href="https://www.washingtonpost.com/wp-dyn/articles/A14939-2004Aug19.html">"Google's IPO: Grate Expectations"</a>. <i>The Washington Post</i>. Washington, D.C. <a rel="nofollow" class="external text" href="https://www.webcitation.org/6BYbWsL9b?url=http://www.washingtonpost.com/wp-dyn/articles/A14939-2004Aug19.html">Archived</a> from the original on October 20, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">February 19,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Washington+Post&amp;rft.atitle=Google%27s+IPO%3A+Grate+Expectations&amp;rft.date=2004-08-19&amp;rft.aulast=Webb&amp;rft.aufirst=Cynthia+L.&amp;rft_id=https%3A%2F%2Fwww.washingtonpost.com%2Fwp-dyn%2Farticles%2FA14939-2004Aug19.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-65">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-65" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFArrington2006" class="citation web cs1">Arrington, Michael (October 9, 2006). <a rel="nofollow" class="external text" href="https://techcrunch.com/2006/10/09/google-has-acquired-youtube/">"Google Has Acquired YouTube"</a>. <i><a href="/wiki/TechCrunch" title="TechCrunch">TechCrunch</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170316024815/https://techcrunch.com/2006/10/09/google-has-acquired-youtube/">Archived</a> from the original on March 16, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 15,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=Google+Has+Acquired+YouTube&amp;rft.date=2006-10-09&amp;rft.aulast=Arrington&amp;rft.aufirst=Michael&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2006%2F10%2F09%2Fgoogle-has-acquired-youtube%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-66">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-66" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSorkinPeters2006" class="citation web cs1">Sorkin, Andrew Ross; Peters, Jeremy W. (October 9, 2006). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2006/10/09/business/09cnd-deal.html">"Google to Acquire YouTube for $1.65 Billion"</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170609080519/http://www.nytimes.com/2006/10/09/business/09cnd-deal.html">Archived</a> from the original on June 9, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 15,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=Google+to+Acquire+YouTube+for+%241.65+Billion&amp;rft.date=2006-10-09&amp;rft.aulast=Sorkin&amp;rft.aufirst=Andrew+Ross&amp;rft.au=Peters%2C+Jeremy+W.&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2006%2F10%2F09%2Fbusiness%2F09cnd-deal.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-67">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-67" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFArrington2006" class="citation web cs1">Arrington, Michael (November 13, 2006). <a rel="nofollow" class="external text" href="https://techcrunch.com/2006/11/13/google-closes-youtube-acquisition/">"Google Closes YouTube Acquisition"</a>. <i><a href="/wiki/TechCrunch" title="TechCrunch">TechCrunch</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170316024500/https://techcrunch.com/2006/11/13/google-closes-youtube-acquisition/">Archived</a> from the original on March 16, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 15,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=Google+Closes+YouTube+Acquisition&amp;rft.date=2006-11-13&amp;rft.aulast=Arrington&amp;rft.aufirst=Michael&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2006%2F11%2F13%2Fgoogle-closes-youtube-acquisition%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-68">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-68" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFAuchard2006" class="citation web cs1">Auchard, Eric (November 14, 2006). <a rel="nofollow" class="external text" href="https://www.reuters.com/article/us-google-idUSWEN973120061114">"Google closes YouTube deal"</a>. <i><a href="/wiki/Reuters" title="Reuters">Reuters</a></i>. <a href="/wiki/Thomson_Reuters" title="Thomson Reuters">Thomson Reuters</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170316113147/http://www.reuters.com/article/us-google-idUSWEN973120061114">Archived</a> from the original on March 16, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 15,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Reuters&amp;rft.atitle=Google+closes+YouTube+deal&amp;rft.date=2006-11-14&amp;rft.aulast=Auchard&amp;rft.aufirst=Eric&amp;rft_id=https%3A%2F%2Fwww.reuters.com%2Farticle%2Fus-google-idUSWEN973120061114&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-69">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-69" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLawsky2008" class="citation news cs1">Lawsky, David (March 11, 2008). <a rel="nofollow" class="external text" href="https://www.reuters.com/article/us-google-doubleclick-eu-idUSBFA00058020080311">"Google closes DoubleClick merger after EU approval"</a>. <i><a href="/wiki/Reuters" title="Reuters">Reuters</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Reuters&amp;rft.atitle=Google+closes+DoubleClick+merger+after+EU+approval&amp;rft.date=2008-03-11&amp;rft.aulast=Lawsky&amp;rft.aufirst=David&amp;rft_id=https%3A%2F%2Fwww.reuters.com%2Farticle%2Fus-google-doubleclick-eu-idUSBFA00058020080311&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-70">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-70" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFStoryHelft2007" class="citation web cs1">Story, Louise; Helft, Miguel (April 14, 2007). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2007/04/14/technology/14DoubleClick.html">"Google Buys DoubleClick for $3.1 Billion"</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170404014741/http://www.nytimes.com/2007/04/14/technology/14DoubleClick.html">Archived</a> from the original on April 4, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 9,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=Google+Buys+DoubleClick+for+%243.1+Billion&amp;rft.date=2007-04-14&amp;rft.aulast=Story&amp;rft.aufirst=Louise&amp;rft.au=Helft%2C+Miguel&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2007%2F04%2F14%2Ftechnology%2F14DoubleClick.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-71">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-71" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWorstall2011" class="citation news cs1">Worstall, Tim (June 22, 2011). <span class="cs1-lock-limited" title="Free access subject to limited trial, subscription normally required"><a rel="nofollow" class="external text" href="https://www.forbes.com/sites/timworstall/2011/06/22/google-hits-one-billion-visitors-in-only-one-month/">"Google Hits One Billion Visitors in Only One Month"</a></span>. <i><a href="/wiki/Forbes" title="Forbes">Forbes</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Forbes&amp;rft.atitle=Google+Hits+One+Billion+Visitors+in+Only+One+Month&amp;rft.date=2011-06-22&amp;rft.aulast=Worstall&amp;rft.aufirst=Tim&amp;rft_id=https%3A%2F%2Fwww.forbes.com%2Fsites%2Ftimworstall%2F2011%2F06%2F22%2Fgoogle-hits-one-billion-visitors-in-only-one-month%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-72">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-72" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFEfrati2011" class="citation news cs1">Efrati, Amir (June 21, 2011). <span class="cs1-lock-subscription" title="Paid subscription required"><a rel="nofollow" class="external text" href="https://www.wsj.com/articles/BL-DGB-22656">"Google Notches One Billion Unique Visitors Per Month"</a></span>. <i><a href="/wiki/The_Wall_Street_Journal" title="The Wall Street Journal">The Wall Street Journal</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Wall+Street+Journal&amp;rft.atitle=Google+Notches+One+Billion+Unique+Visitors+Per+Month&amp;rft.date=2011-06-21&amp;rft.aulast=Efrati&amp;rft.aufirst=Amir&amp;rft_id=https%3A%2F%2Fwww.wsj.com%2Farticles%2FBL-DGB-22656&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-73">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-73" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="https://www.industryweek.com/finance/governance-risk-compliance/article/21957658/google-completes-takeover-of-motorola-mobility">"Google Completes Takeover of Motorola Mobility"</a>. <a href="/wiki/IndustryWeek" title="IndustryWeek">IndustryWeek</a>. <a href="/wiki/Agence_France-Presse" title="Agence France-Presse">Agence France-Presse</a>. May 22, 2012.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Google+Completes+Takeover+of+Motorola+Mobility&amp;rft.date=2012-05-22&amp;rft_id=https%3A%2F%2Fwww.industryweek.com%2Ffinance%2Fgovernance-risk-compliance%2Farticle%2F21957658%2Fgoogle-completes-takeover-of-motorola-mobility&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-74">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-74" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFTsukayama2011" class="citation news cs1">Tsukayama, Hayley (August 15, 2011). <a rel="nofollow" class="external text" href="https://www.washingtonpost.com/blogs/faster-forward/post/google-agrees-to-acquire-motorola-mobility/2011/08/15/gIQABmTkGJ_blog.html">"Google agrees to acquire Motorola Mobility"</a>. <i><a href="/wiki/The_Washington_Post" title="The Washington Post">The Washington Post</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20121113035358/http://www.washingtonpost.com/blogs/faster-forward/post/google-agrees-to-acquire-motorola-mobility/2011/08/15/gIQABmTkGJ_blog.html">Archived</a> from the original on November 13, 2012.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Washington+Post&amp;rft.atitle=Google+agrees+to+acquire+Motorola+Mobility&amp;rft.date=2011-08-15&amp;rft.aulast=Tsukayama&amp;rft.aufirst=Hayley&amp;rft_id=https%3A%2F%2Fwww.washingtonpost.com%2Fblogs%2Ffaster-forward%2Fpost%2Fgoogle-agrees-to-acquire-motorola-mobility%2F2011%2F08%2F15%2FgIQABmTkGJ_blog.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-75">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-75" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://investor.google.com/releases/2011/0815.html">"Google to Acquire Motorola Mobility&nbsp;— Google Investor Relations"</a>. <i>Google</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20110817101741/http://investor.google.com/releases/2011/0815.html">Archived</a> from the original on August 17, 2011<span class="reference-accessdate">. Retrieved <span class="nowrap">August 17,</span> 2011</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Google&amp;rft.atitle=Google+to+Acquire+Motorola+Mobility+%E2%80%94+Google+Investor+Relations&amp;rft_id=http%3A%2F%2Finvestor.google.com%2Freleases%2F2011%2F0815.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-76">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-76" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFPage2011" class="citation web cs1"><a href="/wiki/Larry_Page" title="Larry Page">Page, Larry</a> (August 15, 2011). <a rel="nofollow" class="external text" href="https://googleblog.blogspot.com/2011/08/supercharging-android-google-to-acquire.html">"Official Google Blog: Supercharging Android: Google to Acquire Motorola Mobility"</a>. <i>Official Google Blog</i>. <a rel="nofollow" class="external text" href="https://www.webcitation.org/69UHjJzgs?url=http://googleblog.blogspot.com/2011/08/supercharging-android-google-to-acquire.html">Archived</a> from the original on July 28, 2012.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Official+Google+Blog&amp;rft.atitle=Official+Google+Blog%3A+Supercharging+Android%3A+Google+to+Acquire+Motorola+Mobility&amp;rft.date=2011-08-15&amp;rft.aulast=Page&amp;rft.aufirst=Larry&amp;rft_id=https%3A%2F%2Fgoogleblog.blogspot.com%2F2011%2F08%2Fsupercharging-android-google-to-acquire.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-77">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-77" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHughes2011" class="citation web cs1">Hughes, Neil (August 15, 2011). <a rel="nofollow" class="external text" href="https://appleinsider.com/articles/11/08/15/google_ceo_anticompetitive_apple_microsoft_forced_motorola_deal.html">"Google CEO: 'Anticompetitive' Apple, Microsoft forced Motorola deal"</a>. <i><a href="/wiki/AppleInsider" class="mw-redirect" title="AppleInsider">AppleInsider</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20111210181127/http://www.appleinsider.com/articles/11/08/15/google_ceo_anticompetitive_apple_microsoft_forced_motorola_deal.html">Archived</a> from the original on December 10, 2011.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=AppleInsider&amp;rft.atitle=Google+CEO%3A+%27Anticompetitive%27+Apple%2C+Microsoft+forced+Motorola+deal&amp;rft.date=2011-08-15&amp;rft.aulast=Hughes&amp;rft.aufirst=Neil&amp;rft_id=https%3A%2F%2Fappleinsider.com%2Farticles%2F11%2F08%2F15%2Fgoogle_ceo_anticompetitive_apple_microsoft_forced_motorola_deal.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-cnet-78">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-cnet_78-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFCheng2011" class="citation web cs1">Cheng, Roger (August 15, 2011). <a rel="nofollow" class="external text" href="http://news.cnet.com/8301-1035_3-20092362-94/google-to-buy-motorola-mobility-for-$12.5b/">"Google to buy Motorola Mobility for $12.5B"</a>. <i>CNet News</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20111006062539/http://news.cnet.com/8301-1035_3-20092362-94/google-to-buy-motorola-mobility-for-$12.5b/">Archived</a> from the original on October 6, 2011<span class="reference-accessdate">. Retrieved <span class="nowrap">August 15,</span> 2011</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=CNet+News&amp;rft.atitle=Google+to+buy+Motorola+Mobility+for+%2412.5B&amp;rft.date=2011-08-15&amp;rft.aulast=Cheng&amp;rft.aufirst=Roger&amp;rft_id=http%3A%2F%2Fnews.cnet.com%2F8301-1035_3-20092362-94%2Fgoogle-to-buy-motorola-mobility-for-%2412.5b%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-79">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-79" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKerr2013" class="citation web cs1">Kerr, Dara (July 25, 2013). <a rel="nofollow" class="external text" href="https://www.cnet.com/news/google-reveals-it-spent-966-million-in-waze-acquisition/">"Google reveals it spent $966 million in Waze acquisition"</a>. <i><a href="/wiki/CNET" title="CNET">CNET</a></i>. <a href="/wiki/CBS_Interactive" class="mw-redirect" title="CBS Interactive">CBS Interactive</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170216011658/https://www.cnet.com/news/google-reveals-it-spent-966-million-in-waze-acquisition/">Archived</a> from the original on February 16, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=CNET&amp;rft.atitle=Google+reveals+it+spent+%24966+million+in+Waze+acquisition&amp;rft.date=2013-07-25&amp;rft.aulast=Kerr&amp;rft.aufirst=Dara&amp;rft_id=https%3A%2F%2Fwww.cnet.com%2Fnews%2Fgoogle-reveals-it-spent-966-million-in-waze-acquisition%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-80">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-80" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLunden2013" class="citation web cs1">Lunden, Ingrid (June 11, 2013). <a rel="nofollow" class="external text" href="https://techcrunch.com/2013/06/11/its-official-google-buys-waze-giving-a-social-data-boost-to-its-location-and-mapping-business/">"Google Bought Waze For $1.1B, Giving A Social Data Boost To Its Mapping Business"</a>. <i><a href="/wiki/TechCrunch" title="TechCrunch">TechCrunch</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170706051802/https://techcrunch.com/2013/06/11/its-official-google-buys-waze-giving-a-social-data-boost-to-its-location-and-mapping-business/">Archived</a> from the original on July 6, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=Google+Bought+Waze+For+%241.1B%2C+Giving+A+Social+Data+Boost+To+Its+Mapping+Business&amp;rft.date=2013-06-11&amp;rft.aulast=Lunden&amp;rft.aufirst=Ingrid&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2013%2F06%2F11%2Fits-official-google-buys-waze-giving-a-social-data-boost-to-its-location-and-mapping-business%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-81">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-81" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWakefield2013" class="citation news cs1">Wakefield, Jane (September 19, 2013). <a rel="nofollow" class="external text" href="https://www.bbc.co.uk/news/technology-24158924">"Google spin-off Calico to search for answers to ageing"</a>. <i>BBC News</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20130919201510/http://www.bbc.co.uk/news/technology-24158924">Archived</a> from the original on September 19, 2013<span class="reference-accessdate">. Retrieved <span class="nowrap">September 20,</span> 2013</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=BBC+News&amp;rft.atitle=Google+spin-off+Calico+to+search+for+answers+to+ageing&amp;rft.date=2013-09-19&amp;rft.aulast=Wakefield&amp;rft.aufirst=Jane&amp;rft_id=https%3A%2F%2Fwww.bbc.co.uk%2Fnews%2Ftechnology-24158924&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-82">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-82" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFChowdhry2014" class="citation news cs1">Chowdhry, Amit (January 27, 2014). <a rel="nofollow" class="external text" href="https://www.forbes.com/sites/amitchowdhry/2014/01/27/google-to-acquire-artificial-intelligence-company-deepmind/">"Google To Acquire Artificial Intelligence Company DeepMind"</a>. <i>Forbes</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20140129142153/http://www.forbes.com/sites/amitchowdhry/2014/01/27/google-to-acquire-artificial-intelligence-company-deepmind/">Archived</a> from the original on January 29, 2014<span class="reference-accessdate">. Retrieved <span class="nowrap">January 27,</span> 2014</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Forbes&amp;rft.atitle=Google+To+Acquire+Artificial+Intelligence+Company+DeepMind&amp;rft.date=2014-01-27&amp;rft.aulast=Chowdhry&amp;rft.aufirst=Amit&amp;rft_id=https%3A%2F%2Fwww.forbes.com%2Fsites%2Famitchowdhry%2F2014%2F01%2F27%2Fgoogle-to-acquire-artificial-intelligence-company-deepmind%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-Helgren-_DeepMind-83">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-Helgren-_DeepMind_83-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHelgren2014" class="citation news cs1">Helgren, Chris (January 27, 2014). <a rel="nofollow" class="external text" href="https://www.reuters.com/article/2014/01/27/us-google-deepmind-idUSBREA0Q03220140127">"Google to buy artificial intelligence company DeepMind"</a>. <i>Reuters</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20140127042513/http://www.reuters.com/article/2014/01/27/us-google-deepmind-idUSBREA0Q03220140127">Archived</a> from the original on January 27, 2014<span class="reference-accessdate">. Retrieved <span class="nowrap">January 27,</span> 2014</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Reuters&amp;rft.atitle=Google+to+buy+artificial+intelligence+company+DeepMind&amp;rft.date=2014-01-27&amp;rft.aulast=Helgren&amp;rft.aufirst=Chris&amp;rft_id=https%3A%2F%2Fwww.reuters.com%2Farticle%2F2014%2F01%2F27%2Fus-google-deepmind-idUSBREA0Q03220140127&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-Ribeiro-_DeepMind-84">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-Ribeiro-_DeepMind_84-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFRibeiro2014" class="citation news cs1">Ribeiro, Jon (January 27, 2014). <a rel="nofollow" class="external text" href="http://www.pcworld.com/article/2091500/google-acquires-artificial-intelligence-company-deepmind.html">"Google buys artificial intelligence company DeepMind"</a>. <i>PC World</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20140130042946/http://www.pcworld.com/article/2091500/google-acquires-artificial-intelligence-company-deepmind.html">Archived</a> from the original on January 30, 2014<span class="reference-accessdate">. Retrieved <span class="nowrap">January 27,</span> 2014</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=PC+World&amp;rft.atitle=Google+buys+artificial+intelligence+company+DeepMind&amp;rft.date=2014-01-27&amp;rft.aulast=Ribeiro&amp;rft.aufirst=Jon&amp;rft_id=http%3A%2F%2Fwww.pcworld.com%2Farticle%2F2091500%2Fgoogle-acquires-artificial-intelligence-company-deepmind.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-85">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-85" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFOpam2014" class="citation web cs1">Opam, Kwame (January 26, 2014). <a rel="nofollow" class="external text" href="https://www.theverge.com/2014/1/26/5348640/google-deepmind-acquisition-robotics-ai">"Google buying AI startup DeepMind for a reported $400 million"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170708161602/https://www.theverge.com/2014/1/26/5348640/google-deepmind-acquisition-robotics-ai">Archived</a> from the original on July 8, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 9,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+buying+AI+startup+DeepMind+for+a+reported+%24400+million&amp;rft.date=2014-01-26&amp;rft.aulast=Opam&amp;rft.aufirst=Kwame&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2014%2F1%2F26%2F5348640%2Fgoogle-deepmind-acquisition-robotics-ai&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-86">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-86" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://interbrand.com/best-brands/best-global-brands/2013/ranking/#?listFormat=ls">"Rankings - 2013 - Best Global Brands - Interbrand"</a>. <i>Interbrand</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161022013506/http://interbrand.com/best-brands/best-global-brands/2013/ranking/#?listFormat=ls">Archived</a> from the original on October 22, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">October 23,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Interbrand&amp;rft.atitle=Rankings+-+2013+-+Best+Global+Brands+-+Interbrand&amp;rft_id=http%3A%2F%2Finterbrand.com%2Fbest-brands%2Fbest-global-brands%2F2013%2Franking%2F%23%3FlistFormat%3Dls&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-87">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-87" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://interbrand.com/best-brands/best-global-brands/2014/ranking/#?listFormat=ls">"Rankings - 2014 - Best Global Brands - Interbrand"</a>. <i>Interbrand</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161103140119/http://interbrand.com/best-brands/best-global-brands/2014/ranking/#?listFormat=ls">Archived</a> from the original on November 3, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">October 23,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Interbrand&amp;rft.atitle=Rankings+-+2014+-+Best+Global+Brands+-+Interbrand&amp;rft_id=http%3A%2F%2Finterbrand.com%2Fbest-brands%2Fbest-global-brands%2F2014%2Franking%2F%23%3FlistFormat%3Dls&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-88">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-88" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://interbrand.com/best-brands/best-global-brands/2015/ranking/#?listFormat=ls">"Rankings - 2015 - Best Global Brands - Interbrand"</a>. <i>Interbrand</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161021100708/http://interbrand.com/best-brands/best-global-brands/2015/ranking/#?listFormat=ls">Archived</a> from the original on October 21, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">October 23,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Interbrand&amp;rft.atitle=Rankings+-+2015+-+Best+Global+Brands+-+Interbrand&amp;rft_id=http%3A%2F%2Finterbrand.com%2Fbest-brands%2Fbest-global-brands%2F2015%2Franking%2F%23%3FlistFormat%3Dls&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-89">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-89" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://interbrand.com/best-brands/best-global-brands/2016/ranking/#?listFormat=ls">"Rankings - 2016 - Best Global Brands"</a>. <i>Interbrand</i>. <a rel="nofollow" class="external text" href="https://archive.today/20161220191226/http://interbrand.com/best-brands/best-global-brands/2016/ranking/#?listFormat=ls">Archived</a> from the original on December 20, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">October 23,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Interbrand&amp;rft.atitle=Rankings+-+2016+-+Best+Global+Brands&amp;rft_id=http%3A%2F%2Finterbrand.com%2Fbest-brands%2Fbest-global-brands%2F2016%2Franking%2F%23%3FlistFormat%3Dls&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-90">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-90" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWomack2015" class="citation web cs1">Womack, Brian (August 10, 2015). <a rel="nofollow" class="external text" href="https://www.bloomberg.com/news/articles/2015-08-10/google-to-adopt-new-holding-structure-under-name-alphabet-">"Google Rises After Creating Holding Company Called Alphabet"</a>. <a href="/wiki/Bloomberg_L.P." title="Bloomberg L.P.">Bloomberg L.P.</a> <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161123054841/https://www.bloomberg.com/news/articles/2015-08-10/google-to-adopt-new-holding-structure-under-name-alphabet-">Archived</a> from the original on November 23, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 22,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google+Rises+After+Creating+Holding+Company+Called+Alphabet&amp;rft.pub=Bloomberg+L.P.&amp;rft.date=2015-08-10&amp;rft.aulast=Womack&amp;rft.aufirst=Brian&amp;rft_id=https%3A%2F%2Fwww.bloomberg.com%2Fnews%2Farticles%2F2015-08-10%2Fgoogle-to-adopt-new-holding-structure-under-name-alphabet-&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-91">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-91" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBarrWinkler2015" class="citation news cs1">Barr, Alistair; Winkler, Rolf (August 10, 2015). <a rel="nofollow" class="external text" href="https://www.wsj.com/articles/google-creates-new-company-alphabet-1439240645">"Google Creates Parent Company Called Alphabet in Restructuring"</a>. <i><a href="/wiki/The_Wall_Street_Journal" title="The Wall Street Journal">The Wall Street Journal</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161128112043/http://www.wsj.com/articles/google-creates-new-company-alphabet-1439240645">Archived</a> from the original on November 28, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 22,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Wall+Street+Journal&amp;rft.atitle=Google+Creates+Parent+Company+Called+Alphabet+in+Restructuring&amp;rft.date=2015-08-10&amp;rft.aulast=Barr&amp;rft.aufirst=Alistair&amp;rft.au=Winkler%2C+Rolf&amp;rft_id=https%3A%2F%2Fwww.wsj.com%2Farticles%2Fgoogle-creates-new-company-alphabet-1439240645&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-92">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-92" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFDougherty2015" class="citation web cs1">Dougherty, Conor (August 10, 2015). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2015/08/11/technology/google-alphabet-restructuring.html">"Google to Reorganize as Alphabet to Keep Its Lead as an Innovator"</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161019164806/http://www.nytimes.com/2015/08/11/technology/google-alphabet-restructuring.html">Archived</a> from the original on October 19, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 22,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=Google+to+Reorganize+as+Alphabet+to+Keep+Its+Lead+as+an+Innovator&amp;rft.date=2015-08-10&amp;rft.aulast=Dougherty&amp;rft.aufirst=Conor&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2015%2F08%2F11%2Ftechnology%2Fgoogle-alphabet-restructuring.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-93"><span class="mw-cite-backlink"><b><a href="#cite_ref-93" aria-label="Jump up" title="Jump up">^</a></b></span> <span class="reference-text"><a rel="nofollow" class="external text" href="https://www.nytimes.com/2017/08/07/business/google-women-engineer-fired-memo.html">"Google Fires Engineer Who Wrote Memo Questioning Women in Tech"</a> <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170810185646/https://www.nytimes.com/2017/08/07/business/google-women-engineer-fired-memo.html">Archived</a> August 10, 2017, at the <a href="/wiki/Wayback_Machine" title="Wayback Machine">Wayback Machine</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>, August 7, 2017</span></li>
            <li id="cite_note-94"><span class="mw-cite-backlink"><b><a href="#cite_ref-94" aria-label="Jump up" title="Jump up">^</a></b></span> <span class="reference-text"><a rel="nofollow" class="external text" href="https://www.nytimes.com/2017/08/08/technology/google-engineer-fired-gender-memo.html">Contentious Memo Strikes Nerve Inside Google and Out</a> <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170809012140/https://www.nytimes.com/2017/08/08/technology/google-engineer-fired-gender-memo.html">Archived</a> August 9, 2017, at the <a href="/wiki/Wayback_Machine" title="Wayback Machine">Wayback Machine</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>, August 8, 2017</span></li>
            <li id="cite_note-95"><span class="mw-cite-backlink"><b><a href="#cite_ref-95" aria-label="Jump up" title="Jump up">^</a></b></span> <span class="reference-text">diversitymemo.com</span></li>
            <li id="cite_note-96">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-96" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFFriedersdorf2017" class="citation web cs1">Friedersdorf, Conor (August 8, 2017). <a rel="nofollow" class="external text" href="https://www.theatlantic.com/politics/archive/2017/08/the-most-common-error-in-coverage-of-the-google-memo/536181/">"The Most Common Error in Media Coverage of the Google Memo"</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170808230220/https://www.theatlantic.com/politics/archive/2017/08/the-most-common-error-in-coverage-of-the-google-memo/536181/">Archived</a> from the original on August 8, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">August 9,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=The+Most+Common+Error+in+Media+Coverage+of+the+Google+Memo&amp;rft.date=2017-08-08&amp;rft.aulast=Friedersdorf&amp;rft.aufirst=Conor&amp;rft_id=https%3A%2F%2Fwww.theatlantic.com%2Fpolitics%2Farchive%2F2017%2F08%2Fthe-most-common-error-in-coverage-of-the-google-memo%2F536181%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-BrooksNYT-97">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-BrooksNYT_97-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBrooks2017" class="citation web cs1">Brooks, David (August 11, 2017). <span class="cs1-lock-limited" title="Free access subject to limited trial, subscription normally required"><a rel="nofollow" class="external text" href="https://www.nytimes.com/2017/08/11/opinion/sundar-pichai-google-memo-diversity.html">"Sundar Pichai Should Resign as Google's C.E.O"</a></span>. <i>The New York Times</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170811124216/https://www.nytimes.com/2017/08/11/opinion/sundar-pichai-google-memo-diversity.html">Archived</a> from the original on August 11, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">August 11,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=Sundar+Pichai+Should+Resign+as+Google%27s+C.E.O&amp;rft.date=2017-08-11&amp;rft.aulast=Brooks&amp;rft.aufirst=David&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2017%2F08%2F11%2Fopinion%2Fsundar-pichai-google-memo-diversity.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-98">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-98" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://www.businessinsider.com/david-brooks-sundar-pichai-resignation-james-damore-2017-8">"New York Times columnist David Brooks wants Google's CEO to resign"</a>. <i>Business Insider</i>. August 11, 2017. <a rel="nofollow" class="external text" href="https://archive.today/20170812131604/http://www.businessinsider.com/david-brooks-sundar-pichai-resignation-james-damore-2017-8">Archived</a> from the original on August 12, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">August 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Business+Insider&amp;rft.atitle=New+York+Times+columnist+David+Brooks+wants+Google%27s+CEO+to+resign&amp;rft.date=2017-08-11&amp;rft_id=http%3A%2F%2Fwww.businessinsider.com%2Fdavid-brooks-sundar-pichai-resignation-james-damore-2017-8&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-99">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-99" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBergen2019" class="citation news cs1">Bergen, Mark (November 22, 2019). <a rel="nofollow" class="external text" href="https://www.bloomberg.com/news/articles/2019-11-22/google-workers-protest-company-s-brute-force-intimidation">"Google Workers Protest Company's 'Brute Force Intimidation<span class="cs1-kern-right">'</span>"</a>. <i><a href="/wiki/Bloomberg.com" class="mw-redirect" title="Bloomberg.com">Bloomberg.com</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Bloomberg.com&amp;rft.atitle=Google+Workers+Protest+Company%27s+%27Brute+Force+Intimidation%27&amp;rft.date=2019-11-22&amp;rft.aulast=Bergen&amp;rft.aufirst=Mark&amp;rft_id=https%3A%2F%2Fwww.bloomberg.com%2Fnews%2Farticles%2F2019-11-22%2Fgoogle-workers-protest-company-s-brute-force-intimidation&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-Verge_busting-100">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-Verge_busting_100-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-Verge_busting_100-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHollister2019" class="citation web cs1">Hollister, Sean (November 25, 2019). <a rel="nofollow" class="external text" href="https://www.theverge.com/2019/11/25/20983053/google-fires-four-employees-memo-rebecca-rivers-laurence-berland-union-busting-accusation-walkout">"Google is accused of union busting after firing four employees"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i><span class="reference-accessdate">. Retrieved <span class="nowrap">November 26,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+is+accused+of+union+busting+after+firing+four+employees&amp;rft.date=2019-11-25&amp;rft.aulast=Hollister&amp;rft.aufirst=Sean&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2019%2F11%2F25%2F20983053%2Fgoogle-fires-four-employees-memo-rebecca-rivers-laurence-berland-union-busting-accusation-walkout&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-101">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-101" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWelch2018" class="citation web cs1">Welch, Chris (October 25, 2018). <a rel="nofollow" class="external text" href="https://www.theverge.com/2018/10/25/18024486/google-sexual-harassment-people-fired-rubin-2-years-ceo">"Google says 48 people have been fired for sexual harassment in the last two years"</a>. <i>The Verge</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181031133020/https://www.theverge.com/2018/10/25/18024486/google-sexual-harassment-people-fired-rubin-2-years-ceo">Archived</a> from the original on October 31, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">October 31,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+says+48+people+have+been+fired+for+sexual+harassment+in+the+last+two+years&amp;rft.date=2018-10-25&amp;rft.aulast=Welch&amp;rft.aufirst=Chris&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2018%2F10%2F25%2F18024486%2Fgoogle-sexual-harassment-people-fired-rubin-2-years-ceo&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-102">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-102" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHamilton2018" class="citation web cs1">Hamilton, Isobel Asher;  et&nbsp;al. (November 1, 2018). <a rel="nofollow" class="external text" href="https://www.businessinsider.com/google-walkout-live-pictures-of-protesting-google-workers-2018-11">"PHOTOS: Google employees all over the world left their desk and walked out in protest over sexual misconduct"</a>. <i>Business Insider</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181102174328/https://www.businessinsider.com/google-walkout-live-pictures-of-protesting-google-workers-2018-11">Archived</a> from the original on November 2, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">November 6,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Business+Insider&amp;rft.atitle=PHOTOS%3A+Google+employees+all+over+the+world+left+their+desk+and+walked+out+in+protest+over+sexual+misconduct&amp;rft.date=2018-11-01&amp;rft.aulast=Hamilton&amp;rft.aufirst=Isobel+Asher&amp;rft_id=https%3A%2F%2Fwww.businessinsider.com%2Fgoogle-walkout-live-pictures-of-protesting-google-workers-2018-11&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-103">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-103" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSegarra2018" class="citation news cs1">Segarra, Lisa Marie (November 3, 2018). <a rel="nofollow" class="external text" href="http://fortune.com/2018/11/03/google-employees-walkout-demands/">"More Than 20,000 Google Employees Participated in Walkout Over Sexual Harassment Policy"</a>. Fortune. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181107013331/http://fortune.com/2018/11/03/google-employees-walkout-demands/">Archived</a> from the original on November 7, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">November 6,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=More+Than+20%2C000+Google+Employees+Participated+in+Walkout+Over+Sexual+Harassment+Policy&amp;rft.date=2018-11-03&amp;rft.aulast=Segarra&amp;rft.aufirst=Lisa+Marie&amp;rft_id=http%3A%2F%2Ffortune.com%2F2018%2F11%2F03%2Fgoogle-employees-walkout-demands%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-unveils-104">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-unveils_104-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-unveils_104-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWarren2019" class="citation web cs1">Warren, Tom (March 19, 2019). <a rel="nofollow" class="external text" href="https://www.theverge.com/2019/3/19/18271702/google-stadia-cloud-gaming-service-announcement-gdc-2019">"Google unveils Stadia cloud gaming service, launches in 2019"</a>. <i>The Verge</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190319173136/https://www.theverge.com/2019/3/19/18271702/google-stadia-cloud-gaming-service-announcement-gdc-2019">Archived</a> from the original on March 19, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">April 8,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+unveils+Stadia+cloud+gaming+service%2C+launches+in+2019&amp;rft.date=2019-03-19&amp;rft.aulast=Warren&amp;rft.aufirst=Tom&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2019%2F3%2F19%2F18271702%2Fgoogle-stadia-cloud-gaming-service-announcement-gdc-2019&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-105">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-105" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.theregister.com/2019/06/03/google_shares_take_a_dive_on_doj_reports/">"Google shares take a dive with reports of US DoJ 'competition' probe"</a>. <i>www.theregister.com</i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=www.theregister.com&amp;rft.atitle=Google+shares+take+a+dive+with+reports+of+US+DoJ+%27competition%27+probe&amp;rft_id=https%3A%2F%2Fwww.theregister.com%2F2019%2F06%2F03%2Fgoogle_shares_take_a_dive_on_doj_reports%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-106">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-106" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.npr.org/2020/10/20/925895658/u-s-files-antitrust-suit-against-google">"U.S. Files Antitrust Suit Against Google"</a>. <i>NPR.org</i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=NPR.org&amp;rft.atitle=U.S.+Files+Antitrust+Suit+Against+Google&amp;rft_id=https%3A%2F%2Fwww.npr.org%2F2020%2F10%2F20%2F925895658%2Fu-s-files-antitrust-suit-against-google&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-107">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-107" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFPerez2019" class="citation web cs1">Perez, Sarah (December 11, 2019). <a rel="nofollow" class="external text" href="https://techcrunch.com/2019/12/11/paypals-exiting-coo-bill-ready-to-join-google-as-its-new-president-of-commerce/">"PayPal's exiting COO Bill Ready to join Google as its new president of Commerce"</a>. <i><a href="/wiki/TechCrunch" title="TechCrunch">TechCrunch</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=PayPal%27s+exiting+COO+Bill+Ready+to+join+Google+as+its+new+president+of+Commerce&amp;rft.date=2019-12-11&amp;rft.aulast=Perez&amp;rft.aufirst=Sarah&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2019%2F12%2F11%2Fpaypals-exiting-coo-bill-ready-to-join-google-as-its-new-president-of-commerce%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-108">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-108" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.bloomberg.com/news/articles/2020-04-15/google-to-slow-hiring-for-rest-of-2020-ceo-pichai-tells-staff">"Bloomberg - Google to Slow Hiring for Rest of 2020, CEO Tells Staff"</a>. <i>www.bloomberg.com</i>. April 15, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">April 16,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=www.bloomberg.com&amp;rft.atitle=Bloomberg+-+Google+to+Slow+Hiring+for+Rest+of+2020%2C+CEO+Tells+Staff&amp;rft.date=2020-04-15&amp;rft_id=https%3A%2F%2Fwww.bloomberg.com%2Fnews%2Farticles%2F2020-04-15%2Fgoogle-to-slow-hiring-for-rest-of-2020-ceo-pichai-tells-staff&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-109">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-109" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://news.sky.com/story/google-services-including-gmail-hit-by-serious-disruption-12052892">"Google services including Gmail hit by serious disruption"</a>. <i>Sky News</i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Sky+News&amp;rft.atitle=Google+services+including+Gmail+hit+by+serious+disruption&amp;rft_id=https%3A%2F%2Fnews.sky.com%2Fstory%2Fgoogle-services-including-gmail-hit-by-serious-disruption-12052892&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-110">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-110" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLi2020" class="citation web cs1">Li, Abner (November 12, 2020). <a rel="nofollow" class="external text" href="https://9to5google.com/2020/11/11/youtube-tv-down-2/">"YouTube is currently down amid widespread outage"</a>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=YouTube+is+currently+down+amid+widespread+outage&amp;rft.date=2020-11-12&amp;rft.aulast=Li&amp;rft.aufirst=Abner&amp;rft_id=https%3A%2F%2F9to5google.com%2F2020%2F11%2F11%2Fyoutube-tv-down-2%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-111">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-111" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.techradar.com/amp/news/google-suite-youtube-and-other-services-are-down&amp;ved=0ahUKEwjT_qTet83tAhVJJzQIHcFXB-kQyM8BCCgwAQ&amp;usg=AOvVaw0HFBmVnTnarPXLRK7ok2jE&amp;ampcf=1">"YouTube back online, all services restored as Google apologizes for 'system outage' | TechRadar"</a>. <i>www.techradar.com</i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=www.techradar.com&amp;rft.atitle=YouTube+back+online%2C+all+services+restored+as+Google+apologizes+for+%27system+outage%27+%26%23124%3B+TechRadar&amp;rft_id=https%3A%2F%2Fwww.techradar.com%2Famp%2Fnews%2Fgoogle-suite-youtube-and-other-services-are-down%26ved%3D0ahUKEwjT_qTet83tAhVJJzQIHcFXB-kQyM8BCCgwAQ%26usg%3DAOvVaw0HFBmVnTnarPXLRK7ok2jE%26ampcf%3D1&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-112">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-112" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFJose2021" class="citation news cs1">Jose, Renju (January 22, 2021). <a rel="nofollow" class="external text" href="https://www.reuters.com/article/us-australia-media-google-idUSKBN29R04O">"Google says to block search engine in Australia if forced to pay for news"</a>. <i>Reuters</i><span class="reference-accessdate">. Retrieved <span class="nowrap">January 22,</span> 2021</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Reuters&amp;rft.atitle=Google+says+to+block+search+engine+in+Australia+if+forced+to+pay+for+news&amp;rft.date=2021-01-22&amp;rft.aulast=Jose&amp;rft.aufirst=Renju&amp;rft_id=https%3A%2F%2Fwww.reuters.com%2Farticle%2Fus-australia-media-google-idUSKBN29R04O&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-113">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-113" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.gamesindustry.biz/articles/2021-03-01-google-reportedly-paid-usd20m-for-ubisoft-ports-on-stadia">"Google reportedly paid $20m for Ubisoft ports on Stadia"</a>. <i>GamesIndustry.biz</i><span class="reference-accessdate">. Retrieved <span class="nowrap">March 1,</span> 2021</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=GamesIndustry.biz&amp;rft.atitle=Google+reportedly+paid+%2420m+for+Ubisoft+ports+on+Stadia&amp;rft_id=https%3A%2F%2Fwww.gamesindustry.biz%2Farticles%2F2021-03-01-google-reportedly-paid-usd20m-for-ubisoft-ports-on-stadia&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-114">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-114" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.wsj.com/articles/googles-secret-project-bernanke-revealed-in-texas-antitrust-case-11618097760">"Google's Secret 'Project Bernanke' Revealed in Texas Antitrust Case"</a>. <i><a href="/wiki/The_Wall_Street_Journal" title="The Wall Street Journal">The Wall Street Journal</a></i>. April 11, 2021<span class="reference-accessdate">. Retrieved <span class="nowrap">April 13,</span> 2021</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Wall+Street+Journal&amp;rft.atitle=Google%E2%80%99s+Secret+%E2%80%98Project+Bernanke%E2%80%99+Revealed+in+Texas+Antitrust+Case&amp;rft.date=2021-04-11&amp;rft_id=https%3A%2F%2Fwww.wsj.com%2Farticles%2Fgoogles-secret-project-bernanke-revealed-in-texas-antitrust-case-11618097760&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-115">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-115" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFArrington2008" class="citation web cs1">Arrington, Michael (July 25, 2008). <a rel="nofollow" class="external text" href="https://techcrunch.com/2008/07/25/googles-misleading-blog-post-on-the-size-of-the-web/">"Google's Misleading Blog Post: The Size Of The Web And The Size Of Their Index Are Very Different"</a>. <i><a href="/wiki/TechCrunch" title="TechCrunch">TechCrunch</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170312042335/https://techcrunch.com/2008/07/25/googles-misleading-blog-post-on-the-size-of-the-web/">Archived</a> from the original on March 12, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 9,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=Google%27s+Misleading+Blog+Post%3A+The+Size+Of+The+Web+And+The+Size+Of+Their+Index+Are+Very+Different&amp;rft.date=2008-07-25&amp;rft.aulast=Arrington&amp;rft.aufirst=Michael&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2008%2F07%2F25%2Fgoogles-misleading-blog-post-on-the-size-of-the-web%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-comscore-116">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-comscore_116-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="http://www.comscore.com/Press_Events/Press_Releases/2009/12/comScore_Releases_November_2009_U.S._Search_Engine_Rankings">"comScore Releases November 2009 U.S. Search Engine Rankings"</a>. December 16, 2006. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100225142724/http://www.comscore.com/Press_Events/Press_Releases/2009/12/comScore_Releases_November_2009_U.S._Search_Engine_Rankings">Archived</a> from the original on February 25, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">July 5,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=comScore+Releases+November+2009+U.S.+Search+Engine+Rankings&amp;rft.date=2006-12-16&amp;rft_id=http%3A%2F%2Fwww.comscore.com%2FPress_Events%2FPress_Releases%2F2009%2F12%2FcomScore_Releases_November_2009_U.S._Search_Engine_Rankings&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-117">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-117" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSchwartz2017" class="citation web cs1">Schwartz, Barry (May 26, 2017). <a rel="nofollow" class="external text" href="https://www.seroundtable.com/google-personal-tab-search-23912.html">"Google Adds Personal Tab To Search Filters"</a>. <i>Search Engine Roundtable</i>. RustyBrick. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170527140309/https://www.seroundtable.com/google-personal-tab-search-23912.html">Archived</a> from the original on May 27, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">May 27,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Search+Engine+Roundtable&amp;rft.atitle=Google+Adds+Personal+Tab+To+Search+Filters&amp;rft.date=2017-05-26&amp;rft.aulast=Schwartz&amp;rft.aufirst=Barry&amp;rft_id=https%3A%2F%2Fwww.seroundtable.com%2Fgoogle-personal-tab-search-23912.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-118">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-118" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGartenberg2017" class="citation web cs1">Gartenberg, Chaim (May 26, 2017). <a rel="nofollow" class="external text" href="https://www.theverge.com/2017/5/26/15701778/google-personal-tab-search-results-gmail-photos-images-maps-news-filter">"Google adds new Personal tab to search results to show Gmail and Photos content"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170526215945/https://www.theverge.com/2017/5/26/15701778/google-personal-tab-search-results-gmail-photos-images-maps-news-filter">Archived</a> from the original on May 26, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">May 27,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+adds+new+Personal+tab+to+search+results+to+show+Gmail+and+Photos+content&amp;rft.date=2017-05-26&amp;rft.aulast=Gartenberg&amp;rft.aufirst=Chaim&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2017%2F5%2F26%2F15701778%2Fgoogle-personal-tab-search-results-gmail-photos-images-maps-news-filter&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-119">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-119" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMacht2002" class="citation news cs1">Macht, Joshua (September 30, 2002). <a rel="nofollow" class="external text" href="http://www.time.com/time/business/article/0,8599,356152,00.html">"Automatic for the People"</a>. <i>Time</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20101022094519/http://www.time.com/time/business/article/0,8599,356152,00.html">Archived</a> from the original on October 22, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">June 7,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Time&amp;rft.atitle=Automatic+for+the+People&amp;rft.date=2002-09-30&amp;rft.aulast=Macht&amp;rft.aufirst=Joshua&amp;rft_id=http%3A%2F%2Fwww.time.com%2Ftime%2Fbusiness%2Farticle%2F0%2C8599%2C356152%2C00.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-120">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-120" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMartin2007" class="citation web cs1">Martin, China (November 26, 2007). <a rel="nofollow" class="external text" href="http://www.infoworld.com/t/platforms/google-hit-second-lawsuit-over-library-project-722">"Google hit with second lawsuit over Library project"</a>. <a href="/wiki/InfoWorld" title="InfoWorld">InfoWorld</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20110510022853/http://www.infoworld.com/t/platforms/google-hit-second-lawsuit-over-library-project-722">Archived</a> from the original on May 10, 2011<span class="reference-accessdate">. Retrieved <span class="nowrap">July 5,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google+hit+with+second+lawsuit+over+Library+project&amp;rft.pub=InfoWorld&amp;rft.date=2007-11-26&amp;rft.aulast=Martin&amp;rft.aufirst=China&amp;rft_id=http%3A%2F%2Fwww.infoworld.com%2Ft%2Fplatforms%2Fgoogle-hit-second-lawsuit-over-library-project-722&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-agm2017-121">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-agm2017_121-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation book cs1"><a rel="nofollow" class="external text" href="https://abc.xyz/investor"><i>Annualg report (Alphabet Inc.) - 2017</i></a>. Alphabet Inc. Investor relations. March 1, 2018. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20160203091612/https://abc.xyz/investor/">Archived</a> from the original on February 3, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">December 3,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=book&amp;rft.btitle=Annualg+report+%28Alphabet+Inc.%29+-+2017&amp;rft.pub=Alphabet+Inc.+Investor+relations&amp;rft.date=2018-03-01&amp;rft_id=https%3A%2F%2Fabc.xyz%2Finvestor&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-122">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-122" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFNakashima2008" class="citation news cs1">Nakashima, Ellen (August 12, 2008). <a rel="nofollow" class="external text" href="https://www.washingtonpost.com/wp-dyn/content/article/2008/08/11/AR2008081102270_pf.html">"Some Web Firms Say They Track Behavior Without Explicit Consent"</a>. <i><a href="/wiki/The_Washington_Post" title="The Washington Post">The Washington Post</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20121112172756/http://www.washingtonpost.com/wp-dyn/content/article/2008/08/11/AR2008081102270_pf.html">Archived</a> from the original on November 12, 2012.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Washington+Post&amp;rft.atitle=Some+Web+Firms+Say+They+Track+Behavior+Without+Explicit+Consent&amp;rft.date=2008-08-12&amp;rft.aulast=Nakashima&amp;rft.aufirst=Ellen&amp;rft_id=https%3A%2F%2Fwww.washingtonpost.com%2Fwp-dyn%2Fcontent%2Farticle%2F2008%2F08%2F11%2FAR2008081102270_pf.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-123">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-123" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHelft2009" class="citation web cs1">Helft, Miguel (March 11, 2009). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2009/03/11/technology/internet/11google.html">"Google to Offer Ads Based on Interests"</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170328214358/http://www.nytimes.com/2009/03/11/technology/internet/11google.html">Archived</a> from the original on March 28, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 9,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=Google+to+Offer+Ads+Based+on+Interests&amp;rft.date=2009-03-11&amp;rft.aulast=Helft&amp;rft.aufirst=Miguel&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2009%2F03%2F11%2Ftechnology%2Finternet%2F11google.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-adsense_mobile-124">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-adsense_mobile_124-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/intl/en/press/annc/20070917_mobileads.html">"Google AdSense for Mobile unlocks the potential of the mobile advertising market"</a>. <i>Google, Inc</i>. September 17, 2007. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20120620042233/https://www.google.com/intl/en/press/annc/20070917_mobileads.html">Archived</a> from the original on June 20, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">February 26,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Google%2C+Inc.&amp;rft.atitle=Google+AdSense+for+Mobile+unlocks+the+potential+of+the+mobile+advertising+market&amp;rft.date=2007-09-17&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fintl%2Fen%2Fpress%2Fannc%2F20070917_mobileads.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-125">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-125" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBright2008" class="citation web cs1">Bright, Peter (August 27, 2008). <a rel="nofollow" class="external text" href="https://arstechnica.com/information-technology/2008/08/surfing-on-the-sly-ie8s-inprivate-internet/">"Surfing on the sly with IE8's new "InPrivate" Internet"</a>. <i><a href="/wiki/Ars_Technica" title="Ars Technica">Ars Technica</a></i>. <a href="/wiki/Cond%C3%A9_Nast" title="Condé Nast">Condé Nast</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170312040931/https://arstechnica.com/information-technology/2008/08/surfing-on-the-sly-ie8s-inprivate-internet/">Archived</a> from the original on March 12, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 9,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Ars+Technica&amp;rft.atitle=Surfing+on+the+sly+with+IE8%27s+new+%22InPrivate%22+Internet&amp;rft.date=2008-08-27&amp;rft.aulast=Bright&amp;rft.aufirst=Peter&amp;rft_id=https%3A%2F%2Farstechnica.com%2Finformation-technology%2F2008%2F08%2Fsurfing-on-the-sly-ie8s-inprivate-internet%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-126">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-126" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBeal" class="citation web cs1">Beal, Vangie. <a rel="nofollow" class="external text" href="http://www.webopedia.com/TERM/A/adwords.html">"AdWords - Google AdWords"</a>. <i>Webopedia</i>. QuinStreet Inc. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170629163240/http://www.webopedia.com/TERM/A/adwords.html">Archived</a> from the original on June 29, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">May 27,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Webopedia&amp;rft.atitle=AdWords+-+Google+AdWords&amp;rft.aulast=Beal&amp;rft.aufirst=Vangie&amp;rft_id=http%3A%2F%2Fwww.webopedia.com%2FTERM%2FA%2Fadwords.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-127">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-127" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBeal" class="citation web cs1">Beal, Vangie. <a rel="nofollow" class="external text" href="http://www.webopedia.com/TERM/A/adsense.html">"AdSense - Google AdSense"</a>. <i>Webopedia</i>. QuinStreet Inc. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170502044751/http://www.webopedia.com/TERM/A/adsense.html">Archived</a> from the original on May 2, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">May 27,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Webopedia&amp;rft.atitle=AdSense+-+Google+AdSense&amp;rft.aulast=Beal&amp;rft.aufirst=Vangie&amp;rft_id=http%3A%2F%2Fwww.webopedia.com%2FTERM%2FA%2Fadsense.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-128">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-128" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMills2006" class="citation news cs1">Mills, Elinor (July 25, 2006). <a rel="nofollow" class="external text" href="http://news.cnet.com/Google-to-offer-advertisers-click-fraud-stats/2100-1024_3-6098469.html">"Google to offer advertisers click fraud stats"</a>. <i>news.cnet.com</i>. <a href="/wiki/CNET" title="CNET">CNET</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20110510075216/http://news.cnet.com/Google-to-offer-advertisers-click-fraud-stats/2100-1024_3-6098469.html">Archived</a> from the original on May 10, 2011<span class="reference-accessdate">. Retrieved <span class="nowrap">July 29,</span> 2006</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=news.cnet.com&amp;rft.atitle=Google+to+offer+advertisers+click+fraud+stats&amp;rft.date=2006-07-25&amp;rft.aulast=Mills&amp;rft.aufirst=Elinor&amp;rft_id=http%3A%2F%2Fnews.cnet.com%2FGoogle-to-offer-advertisers-click-fraud-stats%2F2100-1024_3-6098469.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-129">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-129" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGayomali2014" class="citation web cs1">Gayomali, Chris (April 1, 2014). <a rel="nofollow" class="external text" href="https://www.fastcompany.com/3028513/when-gmail-launched-on-april-1-2004-people-thought-it-was-a-joke">"When Gmail Launched On April 1, 2004, People Thought It Was A Joke"</a>. <i><a href="/wiki/Fast_Company_(magazine)" class="mw-redirect" title="Fast Company (magazine)">Fast Company</a></i>. Mansueto Ventures. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20171018201644/https://www.fastcompany.com/3028513/when-gmail-launched-on-april-1-2004-people-thought-it-was-a-joke">Archived</a> from the original on October 18, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Fast+Company&amp;rft.atitle=When+Gmail+Launched+On+April+1%2C+2004%2C+People+Thought+It+Was+A+Joke&amp;rft.date=2014-04-01&amp;rft.aulast=Gayomali&amp;rft.aufirst=Chris&amp;rft_id=https%3A%2F%2Fwww.fastcompany.com%2F3028513%2Fwhen-gmail-launched-on-april-1-2004-people-thought-it-was-a-joke&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-130">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-130" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFVincent2017" class="citation web cs1">Vincent, James (January 5, 2017). <a rel="nofollow" class="external text" href="https://www.theverge.com/2017/1/5/14175830/google-calendar-track-fitness-goals-health-data">"Google Calendar update makes it easier to track your New Year's fitness goals"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170113025213/http://www.theverge.com/2017/1/5/14175830/google-calendar-track-fitness-goals-health-data">Archived</a> from the original on January 13, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+Calendar+update+makes+it+easier+to+track+your+New+Year%27s+fitness+goals&amp;rft.date=2017-01-05&amp;rft.aulast=Vincent&amp;rft.aufirst=James&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2017%2F1%2F5%2F14175830%2Fgoogle-calendar-track-fitness-goals-health-data&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-131">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-131" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBroussard2017" class="citation web cs1">Broussard, Mitchel (March 22, 2017). <a rel="nofollow" class="external text" href="https://www.macrumors.com/2017/03/22/google-maps-location-sharing/">"Google Maps Introduces New Location Sharing Feature With Real-Time Friend Tracking"</a>. <i><a href="/wiki/MacRumors" title="MacRumors">MacRumors</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170327173708/https://www.macrumors.com/2017/03/22/google-maps-location-sharing/">Archived</a> from the original on March 27, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=MacRumors&amp;rft.atitle=Google+Maps+Introduces+New+Location+Sharing+Feature+With+Real-Time+Friend+Tracking&amp;rft.date=2017-03-22&amp;rft.aulast=Broussard&amp;rft.aufirst=Mitchel&amp;rft_id=https%3A%2F%2Fwww.macrumors.com%2F2017%2F03%2F22%2Fgoogle-maps-location-sharing%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-verge-drive-announced-132">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-verge-drive-announced_132-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-verge-drive-announced_132-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSottek2012" class="citation web cs1">Sottek, T.C. (April 24, 2012). <a rel="nofollow" class="external text" href="https://www.theverge.com/2012/4/24/2971025/google-drive-official-launch-features">"Google Drive officially launches with 5&nbsp;GB free storage, Google Docs integration"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161226161807/http://www.theverge.com/2012/4/24/2971025/google-drive-official-launch-features">Archived</a> from the original on December 26, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+Drive+officially+launches+with+5+GB+free+storage%2C+Google+Docs+integration&amp;rft.date=2012-04-24&amp;rft.aulast=Sottek&amp;rft.aufirst=T.C.&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2012%2F4%2F24%2F2971025%2Fgoogle-drive-official-launch-features&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-133">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-133" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFPerez2015" class="citation web cs1">Perez, Sarah (May 28, 2015). <a rel="nofollow" class="external text" href="https://techcrunch.com/2015/05/28/google-photos-breaks-free-of-google-now-offers-free-unlimited-storage/">"Google Photos Breaks Free Of Google+, Now Offers Free, Unlimited Storage"</a>. <i><a href="/wiki/TechCrunch" title="TechCrunch">TechCrunch</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170706135643/https://techcrunch.com/2015/05/28/google-photos-breaks-free-of-google-now-offers-free-unlimited-storage/">Archived</a> from the original on July 6, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=Google+Photos+Breaks+Free+Of+Google%2B%2C+Now+Offers+Free%2C+Unlimited+Storage&amp;rft.date=2015-05-28&amp;rft.aulast=Perez&amp;rft.aufirst=Sarah&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2015%2F05%2F28%2Fgoogle-photos-breaks-free-of-google-now-offers-free-unlimited-storage%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-134">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-134" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGraziano2013" class="citation web cs1">Graziano, Dan (March 20, 2013). <a rel="nofollow" class="external text" href="http://bgr.com/2013/03/20/google-keep-annnounced-388095/">"Google launches Google Keep note-taking service [video]"</a>. <i><a href="/wiki/Boy_Genius_Report" title="Boy Genius Report">BGR</a></i>. <a href="/wiki/Penske_Media_Corporation" title="Penske Media Corporation">Penske Media Corporation</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161008154306/http://bgr.com/2013/03/20/google-keep-annnounced-388095/">Archived</a> from the original on October 8, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=BGR&amp;rft.atitle=Google+launches+Google+Keep+note-taking+service+%5Bvideo%5D&amp;rft.date=2013-03-20&amp;rft.aulast=Graziano&amp;rft.aufirst=Dan&amp;rft_id=http%3A%2F%2Fbgr.com%2F2013%2F03%2F20%2Fgoogle-keep-annnounced-388095%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-135">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-135" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFEadicicco2016" class="citation web cs1">Eadicicco, Lisa (November 16, 2016). <a rel="nofollow" class="external text" href="http://time.com/4572942/google-translate-app-update-2016/">"Google's Translation App Is About To Get Much Better"</a>. <i><a href="/wiki/Time_(magazine)" title="Time (magazine)">Time</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170401152526/http://time.com/4572942/google-translate-app-update-2016/">Archived</a> from the original on April 1, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Time&amp;rft.atitle=Google%27s+Translation+App+Is+About+To+Get+Much+Better&amp;rft.date=2016-11-16&amp;rft.aulast=Eadicicco&amp;rft.aufirst=Lisa&amp;rft_id=http%3A%2F%2Ftime.com%2F4572942%2Fgoogle-translate-app-update-2016%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-136">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-136" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHamedy2017" class="citation web cs1">Hamedy, Saba (February 28, 2017). <a rel="nofollow" class="external text" href="http://mashable.com/2017/02/27/youtube-one-billion-hours-of-video-daily/">"People now spend 1 billion hours watching YouTube every day"</a>. <i><a href="/wiki/Mashable" title="Mashable">Mashable</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170517233015/http://mashable.com/2017/02/27/youtube-one-billion-hours-of-video-daily/">Archived</a> from the original on May 17, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Mashable&amp;rft.atitle=People+now+spend+1+billion+hours+watching+YouTube+every+day&amp;rft.date=2017-02-28&amp;rft.aulast=Hamedy&amp;rft.aufirst=Saba&amp;rft_id=http%3A%2F%2Fmashable.com%2F2017%2F02%2F27%2Fyoutube-one-billion-hours-of-video-daily%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-137">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-137" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/business/">"Google My Business – Stand Out on Google for Free"</a>. <i>www.google.com</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190207151521/https://www.google.com/business/">Archived</a> from the original on February 7, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">February 6,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=www.google.com&amp;rft.atitle=Google+My+Business+%E2%80%93+Stand+Out+on+Google+for+Free&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fbusiness%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-138">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-138" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLevy2011" class="citation magazine cs1">Levy, Steven (June 28, 2011). <a rel="nofollow" class="external text" href="https://www.wired.com/2011/06/inside-google-plus-social/">"Inside Google+ - How the search giant plans to go social"</a>. <i><a href="/wiki/Wired_(website)" class="mw-redirect" title="Wired (website)">Wired</a></i>. <a href="/wiki/Cond%C3%A9_Nast" title="Condé Nast">Condé Nast</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170405130052/https://www.wired.com/2011/06/inside-google-plus-social/">Archived</a> from the original on April 5, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Wired&amp;rft.atitle=Inside+Google%2B+-+How+the+search+giant+plans+to+go+social&amp;rft.date=2011-06-28&amp;rft.aulast=Levy&amp;rft.aufirst=Steven&amp;rft_id=https%3A%2F%2Fwww.wired.com%2F2011%2F06%2Finside-google-plus-social%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-139">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-139" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFClarke,_PhilippaAilshire,_JenniferMelendez,_RobertBader,_Michael2010" class="citation journal cs1">Clarke, Philippa; Ailshire, Jennifer; Melendez, Robert; Bader, Michael; Morenoff, Jeffrey (2010). <a rel="nofollow" class="external text" href="https://pubmed.ncbi.nlm.nih.gov/20797897">"Using Google Earth to conduct a neighborhood audit: reliability of a virtual audit instrument"</a>. <i>Health &amp; Place</i>. <b>16</b> (6): 1224–1229. <a href="/wiki/Doi_(identifier)" class="mw-redirect" title="Doi (identifier)">doi</a>:<a rel="nofollow" class="external text" href="https://doi.org/10.1016%2Fj.healthplace.2010.08.007">10.1016/j.healthplace.2010.08.007</a>. <a href="/wiki/PMC_(identifier)" class="mw-redirect" title="PMC (identifier)">PMC</a>&nbsp;<span class="cs1-lock-free" title="Freely accessible"><a rel="nofollow" class="external text" href="//www.ncbi.nlm.nih.gov/pmc/articles/PMC2952684">2952684</a></span>. <a href="/wiki/PMID_(identifier)" class="mw-redirect" title="PMID (identifier)">PMID</a>&nbsp;<a rel="nofollow" class="external text" href="//pubmed.ncbi.nlm.nih.gov/20797897">20797897</a> – via PubMed.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Health+%26+Place&amp;rft.atitle=Using+Google+Earth+to+conduct+a+neighborhood+audit%3A+reliability+of+a+virtual+audit+instrument&amp;rft.volume=16&amp;rft.issue=6&amp;rft.pages=1224-1229&amp;rft.date=2010&amp;rft_id=%2F%2Fwww.ncbi.nlm.nih.gov%2Fpmc%2Farticles%2FPMC2952684%23id-name%3DPMC&amp;rft_id=info%3Apmid%2F20797897&amp;rft_id=info%3Adoi%2F10.1016%2Fj.healthplace.2010.08.007&amp;rft.au=Clarke%2C+Philippa&amp;rft.au=Ailshire%2C+Jennifer&amp;rft.au=Melendez%2C+Robert&amp;rft.au=Bader%2C+Michael&amp;rft.au=Morenoff%2C+Jeffrey&amp;rft_id=https%3A%2F%2Fpubmed.ncbi.nlm.nih.gov%2F20797897&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-140">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-140" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSchonfeld2007" class="citation web cs1">Schonfeld, Erick (November 5, 2007). <a rel="nofollow" class="external text" href="https://techcrunch.com/2007/11/05/breaking-google-announces-android-and-open-handset-alliance/">"Breaking: Google Announces Android and Open Handset Alliance"</a>. <i><a href="/wiki/TechCrunch" title="TechCrunch">TechCrunch</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170622140334/https://techcrunch.com/2007/11/05/breaking-google-announces-android-and-open-handset-alliance/">Archived</a> from the original on June 22, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=Breaking%3A+Google+Announces+Android+and+Open+Handset+Alliance&amp;rft.date=2007-11-05&amp;rft.aulast=Schonfeld&amp;rft.aufirst=Erick&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2007%2F11%2F05%2Fbreaking-google-announces-android-and-open-handset-alliance%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-141">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-141" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFD'Orazio2014" class="citation web cs1">D'Orazio, Dante (March 18, 2014). <a rel="nofollow" class="external text" href="https://www.theverge.com/2014/3/18/5522226/google-reveals-android-wear-an-operating-system-designed-for">"Google reveals Android Wear, an operating system for smartwatches"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170210034323/http://www.theverge.com/2014/3/18/5522226/google-reveals-android-wear-an-operating-system-designed-for">Archived</a> from the original on February 10, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">April 4,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+reveals+Android+Wear%2C+an+operating+system+for+smartwatches&amp;rft.date=2014-03-18&amp;rft.aulast=D%27Orazio&amp;rft.aufirst=Dante&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2014%2F3%2F18%2F5522226%2Fgoogle-reveals-android-wear-an-operating-system-designed-for&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-142">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-142" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFOng2014" class="citation web cs1">Ong, Josh (June 25, 2014). <a rel="nofollow" class="external text" href="https://thenextweb.com/google/2014/06/25/android-tv-google-io-2014/">"Google announces Android TV to bring 'voice input, user experience and content' to the living room"</a>. <i>The Next Web</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170313130445/https://thenextweb.com/google/2014/06/25/android-tv-google-io-2014/">Archived</a> from the original on March 13, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">April 4,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Next+Web&amp;rft.atitle=Google+announces+Android+TV+to+bring+%27voice+input%2C+user+experience+and+content%27+to+the+living+room&amp;rft.date=2014-06-25&amp;rft.aulast=Ong&amp;rft.aufirst=Josh&amp;rft_id=https%3A%2F%2Fthenextweb.com%2Fgoogle%2F2014%2F06%2F25%2Fandroid-tv-google-io-2014%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-143">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-143" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWilhelm2014" class="citation web cs1">Wilhelm, Alex (June 25, 2014). <a rel="nofollow" class="external text" href="https://techcrunch.com/2014/06/25/google-announces-android-auto-promises-enabled-cars-by-end-of-2014/">"Google Announces Android Auto, Promises Enabled Cars By The End Of 2014"</a>. <i><a href="/wiki/TechCrunch" title="TechCrunch">TechCrunch</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170622135917/https://techcrunch.com/2014/06/25/google-announces-android-auto-promises-enabled-cars-by-end-of-2014/">Archived</a> from the original on June 22, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">April 4,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=Google+Announces+Android+Auto%2C+Promises+Enabled+Cars+By+The+End+Of+2014&amp;rft.date=2014-06-25&amp;rft.aulast=Wilhelm&amp;rft.aufirst=Alex&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2014%2F06%2F25%2Fgoogle-announces-android-auto-promises-enabled-cars-by-end-of-2014%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-144">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-144" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKastrenakes2016" class="citation web cs1">Kastrenakes, Jacob (December 13, 2016). <a rel="nofollow" class="external text" href="https://www.theverge.com/2016/12/13/13924996/android-things-announced-smart-home-iot-operating-system">"Android Things is Google's new OS for smart devices"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170217131058/http://www.theverge.com/2016/12/13/13924996/android-things-announced-smart-home-iot-operating-system">Archived</a> from the original on February 17, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">April 4,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Android+Things+is+Google%27s+new+OS+for+smart+devices&amp;rft.date=2016-12-13&amp;rft.aulast=Kastrenakes&amp;rft.aufirst=Jacob&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2016%2F12%2F13%2F13924996%2Fandroid-things-announced-smart-home-iot-operating-system&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-145">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-145" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFPichaiUpson2008" class="citation web cs1">Pichai, Sundar; Upson, Linus (September 1, 2008). <a rel="nofollow" class="external text" href="https://googleblog.blogspot.no/2008/09/fresh-take-on-browser.html">"A fresh take on the browser"</a>. <i>Official Google Blog</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20160315022315/https://googleblog.blogspot.no/2008/09/fresh-take-on-browser.html">Archived</a> from the original on March 15, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 22,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Official+Google+Blog&amp;rft.atitle=A+fresh+take+on+the+browser&amp;rft.date=2008-09-01&amp;rft.aulast=Pichai&amp;rft.aufirst=Sundar&amp;rft.au=Upson%2C+Linus&amp;rft_id=https%3A%2F%2Fgoogleblog.blogspot.no%2F2008%2F09%2Ffresh-take-on-browser.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-146">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-146" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFPichaiUpson2009" class="citation web cs1">Pichai, Sundar; Upson, Linus (July 7, 2009). <a rel="nofollow" class="external text" href="https://googleblog.blogspot.no/2009/07/introducing-google-chrome-os.html">"Introducing the Google Chrome OS"</a>. <i>Official Google Blog</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161122222918/https://googleblog.blogspot.no/2009/07/introducing-google-chrome-os.html">Archived</a> from the original on November 22, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 22,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Official+Google+Blog&amp;rft.atitle=Introducing+the+Google+Chrome+OS&amp;rft.date=2009-07-07&amp;rft.aulast=Pichai&amp;rft.aufirst=Sundar&amp;rft.au=Upson%2C+Linus&amp;rft_id=https%3A%2F%2Fgoogleblog.blogspot.no%2F2009%2F07%2Fintroducing-google-chrome-os.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-147">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-147" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSiegler2010" class="citation web cs1">Siegler, MG (January 5, 2010). <a rel="nofollow" class="external text" href="https://techcrunch.com/2010/01/05/nexus-one-event/">"The Droid You're Looking For: Live From The Nexus One Event"</a>. <i><a href="/wiki/TechCrunch" title="TechCrunch">TechCrunch</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161123054909/https://techcrunch.com/2010/01/05/nexus-one-event/">Archived</a> from the original on November 23, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 22,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=The+Droid+You%27re+Looking+For%3A+Live+From+The+Nexus+One+Event&amp;rft.date=2010-01-05&amp;rft.aulast=Siegler&amp;rft.aufirst=MG&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2010%2F01%2F05%2Fnexus-one-event%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-148">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-148" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFIon2013" class="citation web cs1">Ion, Florence (May 15, 2013). <a rel="nofollow" class="external text" href="https://arstechnica.com/gadgets/2013/05/from-the-nexus-one-to-the-nexus-10-a-brief-history-of-nexus-devices/">"From Nexus One to Nexus 10: a brief history of Google's flagship devices"</a>. <i><a href="/wiki/Ars_Technica" title="Ars Technica">Ars Technica</a></i>. <a href="/wiki/Cond%C3%A9_Nast" title="Condé Nast">Condé Nast</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170624004245/https://arstechnica.com/gadgets/2013/05/from-the-nexus-one-to-the-nexus-10-a-brief-history-of-nexus-devices/">Archived</a> from the original on June 24, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Ars+Technica&amp;rft.atitle=From+Nexus+One+to+Nexus+10%3A+a+brief+history+of+Google%27s+flagship+devices&amp;rft.date=2013-05-15&amp;rft.aulast=Ion&amp;rft.aufirst=Florence&amp;rft_id=https%3A%2F%2Farstechnica.com%2Fgadgets%2F2013%2F05%2Ffrom-the-nexus-one-to-the-nexus-10-a-brief-history-of-nexus-devices%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-Pixel_inside_story-149">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-Pixel_inside_story_149-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBohn2016" class="citation web cs1">Bohn, Dieter (October 4, 2016). <a rel="nofollow" class="external text" href="https://www.theverge.com/a/google-pixel-phone-new-hardware-interview-2016">"The Google Phone: The inside story of Google's bold bet on hardware"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170106213353/http://www.theverge.com/a/google-pixel-phone-new-hardware-interview-2016">Archived</a> from the original on January 6, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=The+Google+Phone%3A+The+inside+story+of+Google%27s+bold+bet+on+hardware&amp;rft.date=2016-10-04&amp;rft.aulast=Bohn&amp;rft.aufirst=Dieter&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2Fa%2Fgoogle-pixel-phone-new-hardware-interview-2016&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-150">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-150" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFPichaiUpson2011" class="citation web cs1">Pichai, Sundar; Upson, Linus (May 11, 2011). <a rel="nofollow" class="external text" href="https://googleblog.blogspot.no/2011/05/new-kind-of-computer-chromebook.html">"A new kind of computer: Chromebook"</a>. <i>Official Google Blog</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161122222651/https://googleblog.blogspot.no/2011/05/new-kind-of-computer-chromebook.html">Archived</a> from the original on November 22, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 22,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Official+Google+Blog&amp;rft.atitle=A+new+kind+of+computer%3A+Chromebook&amp;rft.date=2011-05-11&amp;rft.aulast=Pichai&amp;rft.aufirst=Sundar&amp;rft.au=Upson%2C+Linus&amp;rft_id=https%3A%2F%2Fgoogleblog.blogspot.no%2F2011%2F05%2Fnew-kind-of-computer-chromebook.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-151">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-151" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFRobertson2013" class="citation web cs1">Robertson, Adi (July 24, 2013). <a rel="nofollow" class="external text" href="https://www.theverge.com/2013/7/24/4552204/google-reveals-chromecast-tv-streaming">"Google reveals Chromecast: video streaming to your TV from any device for $35"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161226065215/http://www.theverge.com/2013/7/24/4552204/google-reveals-chromecast-tv-streaming">Archived</a> from the original on December 26, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 29,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+reveals+Chromecast%3A+video+streaming+to+your+TV+from+any+device+for+%2435&amp;rft.date=2013-07-24&amp;rft.aulast=Robertson&amp;rft.aufirst=Adi&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2013%2F7%2F24%2F4552204%2Fgoogle-reveals-chromecast-tv-streaming&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-152">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-152" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.bbc.com/news/technology-23514400">"Google Chromecast takes on streaming content to TV"</a>. <i><a href="/wiki/BBC_News" title="BBC News">BBC News</a></i>. <a href="/wiki/BBC" title="BBC">BBC</a>. July 31, 2013. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161129205929/http://www.bbc.com/news/technology-23514400">Archived</a> from the original on November 29, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 29,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=BBC+News&amp;rft.atitle=Google+Chromecast+takes+on+streaming+content+to+TV&amp;rft.date=2013-07-31&amp;rft_id=https%3A%2F%2Fwww.bbc.com%2Fnews%2Ftechnology-23514400&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-153">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-153" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFO'Toole2014" class="citation web cs1">O'Toole, James (June 26, 2014). <a rel="nofollow" class="external text" href="https://money.cnn.com/2014/06/25/technology/innovation/google-cardboard/">"Google's cardboard virtual-reality goggles"</a>. <a href="/wiki/CNN" title="CNN">CNN</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161129145138/http://money.cnn.com/2014/06/25/technology/innovation/google-cardboard/">Archived</a> from the original on November 29, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 29,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google%27s+cardboard+virtual-reality+goggles&amp;rft.pub=CNN&amp;rft.date=2014-06-26&amp;rft.aulast=O%27Toole&amp;rft.aufirst=James&amp;rft_id=https%3A%2F%2Fmoney.cnn.com%2F2014%2F06%2F25%2Ftechnology%2Finnovation%2Fgoogle-cardboard%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-154">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-154" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKain2014" class="citation web cs1">Kain, Erik (June 26, 2014). <a rel="nofollow" class="external text" href="https://www.forbes.com/sites/erikkain/2014/06/26/google-cardboard-is-googles-awesomely-weird-answer-to-virtual-reality/">"Google Cardboard Is Google's Awesomely Weird Answer To Virtual Reality"</a>. <i><a href="/wiki/Forbes" title="Forbes">Forbes</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161129151747/http://www.forbes.com/sites/erikkain/2014/06/26/google-cardboard-is-googles-awesomely-weird-answer-to-virtual-reality/">Archived</a> from the original on November 29, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 29,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Forbes&amp;rft.atitle=Google+Cardboard+Is+Google%27s+Awesomely+Weird+Answer+To+Virtual+Reality&amp;rft.date=2014-06-26&amp;rft.aulast=Kain&amp;rft.aufirst=Erik&amp;rft_id=https%3A%2F%2Fwww.forbes.com%2Fsites%2Ferikkain%2F2014%2F06%2F26%2Fgoogle-cardboard-is-googles-awesomely-weird-answer-to-virtual-reality%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-155">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-155" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBohn2016" class="citation web cs1">Bohn, Dieter (October 4, 2016). <a rel="nofollow" class="external text" href="https://www.theverge.com/2016/10/4/13156676/google-home-assistant-speaker-photos-video-device-hands-on">"Google Home is smart, loud, and kind of cute"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161007204916/http://www.theverge.com/2016/10/4/13156676/google-home-assistant-speaker-photos-video-device-hands-on">Archived</a> from the original on October 7, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">October 8,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+Home+is+smart%2C+loud%2C+and+kind+of+cute&amp;rft.date=2016-10-04&amp;rft.aulast=Bohn&amp;rft.aufirst=Dieter&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2016%2F10%2F4%2F13156676%2Fgoogle-home-assistant-speaker-photos-video-device-hands-on&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-156">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-156" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFRobertsonKastrenakes2016" class="citation web cs1">Robertson, Adi; Kastrenakes, Jacob (October 4, 2016). <a rel="nofollow" class="external text" href="https://www.theverge.com/2016/10/4/13161506/google-vr-headset-photos-daydream-view-virtual-reality">"Google's Daydream View VR headset goes on sale next month for $79"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161007203651/http://www.theverge.com/2016/10/4/13161506/google-vr-headset-photos-daydream-view-virtual-reality">Archived</a> from the original on October 7, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">October 8,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google%27s+Daydream+View+VR+headset+goes+on+sale+next+month+for+%2479&amp;rft.date=2016-10-04&amp;rft.aulast=Robertson&amp;rft.aufirst=Adi&amp;rft.au=Kastrenakes%2C+Jacob&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2016%2F10%2F4%2F13161506%2Fgoogle-vr-headset-photos-daydream-view-virtual-reality&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-157">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-157" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBohn2016" class="citation web cs1">Bohn, Dieter (October 4, 2016). <a rel="nofollow" class="external text" href="https://www.theverge.com/2016/10/4/13157680/google-wifi-router-photos-hands-on">"The Google Wifi routers are little white pucks you can scatter throughout your house"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161007180430/http://www.theverge.com/2016/10/4/13157680/google-wifi-router-photos-hands-on">Archived</a> from the original on October 7, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">October 8,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=The+Google+Wifi+routers+are+little+white+pucks+you+can+scatter+throughout+your+house&amp;rft.date=2016-10-04&amp;rft.aulast=Bohn&amp;rft.aufirst=Dieter&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2016%2F10%2F4%2F13157680%2Fgoogle-wifi-router-photos-hands-on&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-158">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-158" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://cloud.google.com/blog/products/workspace/introducing-google-workspace/">"Announcing Google Workspace, everything you need to get it done, in one location"</a>. <i>Google Cloud Blog</i><span class="reference-accessdate">. Retrieved <span class="nowrap">October 24,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Google+Cloud+Blog&amp;rft.atitle=Announcing+Google+Workspace%2C+everything+you+need+to+get+it+done%2C+in+one+location&amp;rft_id=https%3A%2F%2Fcloud.google.com%2Fblog%2Fproducts%2Fworkspace%2Fintroducing-google-workspace%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-159">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-159" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://gsuite.google.com/intl/en_ie/pricing.html">"Choose a Plan"</a>. <i>G Suite by Google Cloud</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161212231639/https://gsuite.google.com/intl/en_ie/pricing.html">Archived</a> from the original on December 12, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">December 2,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=G+Suite+by+Google+Cloud&amp;rft.atitle=Choose+a+Plan&amp;rft_id=https%3A%2F%2Fgsuite.google.com%2Fintl%2Fen_ie%2Fpricing.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-160">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-160" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://googleblog.blogspot.com/2012/09/celebrating-spirit-of-entrepreneurship.html">"Celebrating the spirit of entrepreneurship with the new Google for Entrepreneurs"</a>. <i>Official Google Blog</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180320171207/https://googleblog.blogspot.com/2012/09/celebrating-spirit-of-entrepreneurship.html">Archived</a> from the original on March 20, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">March 20,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Official+Google+Blog&amp;rft.atitle=Celebrating+the+spirit+of+entrepreneurship+with+the+new+Google+for+Entrepreneurs&amp;rft_id=https%3A%2F%2Fgoogleblog.blogspot.com%2F2012%2F09%2Fcelebrating-spirit-of-entrepreneurship.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-161">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-161" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFFell2012" class="citation news cs1">Fell, Jason (September 27, 2012). <a rel="nofollow" class="external text" href="https://www.entrepreneur.com/article/224522">"How Google Wants to Make Starting Up Easier for Entrepreneurs"</a>. <i>Entrepreneur</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180320230407/https://www.entrepreneur.com/article/224522">Archived</a> from the original on March 20, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">March 20,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Entrepreneur&amp;rft.atitle=How+Google+Wants+to+Make+Starting+Up+Easier+for+Entrepreneurs&amp;rft.date=2012-09-27&amp;rft.aulast=Fell&amp;rft.aufirst=Jason&amp;rft_id=https%3A%2F%2Fwww.entrepreneur.com%2Farticle%2F224522&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-162">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-162" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMuret2016" class="citation web cs1">Muret, Paul (March 15, 2016). <a rel="nofollow" class="external text" href="https://analytics.googleblog.com/2016/03/introducing-google-analytics-360-suite.html">"Introducing the Google Analytics 360 Suite"</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170112142850/https://analytics.googleblog.com/2016/03/introducing-google-analytics-360-suite.html">Archived</a> from the original on January 12, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">January 22,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Introducing+the+Google+Analytics+360+Suite&amp;rft.date=2016-03-15&amp;rft.aulast=Muret&amp;rft.aufirst=Paul&amp;rft_id=https%3A%2F%2Fanalytics.googleblog.com%2F2016%2F03%2Fintroducing-google-analytics-360-suite.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-163">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-163" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMarshall2016" class="citation news cs1">Marshall, Jack (March 15, 2016). <a rel="nofollow" class="external text" href="https://www.wsj.com/articles/google-launches-new-data-tools-for-marketers-1458043217">"Google Launches New Data Tools for Marketers"</a>. <i><a href="/wiki/The_Wall_Street_Journal" title="The Wall Street Journal">The Wall Street Journal</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161113150024/http://www.wsj.com/articles/google-launches-new-data-tools-for-marketers-1458043217">Archived</a> from the original on November 13, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">January 22,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Wall+Street+Journal&amp;rft.atitle=Google+Launches+New+Data+Tools+for+Marketers&amp;rft.date=2016-03-15&amp;rft.aulast=Marshall&amp;rft.aufirst=Jack&amp;rft_id=https%3A%2F%2Fwww.wsj.com%2Farticles%2Fgoogle-launches-new-data-tools-for-marketers-1458043217&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-164">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-164" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFIngersollKelly2010" class="citation web cs1">Ingersoll, Minnie; Kelly, James (February 10, 2010). <a rel="nofollow" class="external text" href="https://googleblog.blogspot.no/2010/02/think-big-with-gig-our-experimental.html">"Think big with a gig: Our experimental fiber network"</a>. <i>Official Google Blog</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161129150926/https://googleblog.blogspot.no/2010/02/think-big-with-gig-our-experimental.html">Archived</a> from the original on November 29, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 29,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Official+Google+Blog&amp;rft.atitle=Think+big+with+a+gig%3A+Our+experimental+fiber+network&amp;rft.date=2010-02-10&amp;rft.aulast=Ingersoll&amp;rft.aufirst=Minnie&amp;rft.au=Kelly%2C+James&amp;rft_id=https%3A%2F%2Fgoogleblog.blogspot.no%2F2010%2F02%2Fthink-big-with-gig-our-experimental.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-165">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-165" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSchonfeld2010" class="citation web cs1">Schonfeld, Erick (February 10, 2010). <a rel="nofollow" class="external text" href="https://techcrunch.com/2010/02/10/google-fiber-optic-network-home/">"Google Plans To Deliver 1Gb/sec Fiber-Optic Broadband Network To More Than 50,000 Homes"</a>. <i><a href="/wiki/TechCrunch" title="TechCrunch">TechCrunch</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161129145628/https://techcrunch.com/2010/02/10/google-fiber-optic-network-home/">Archived</a> from the original on November 29, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 29,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=Google+Plans+To+Deliver+1Gb%2Fsec+Fiber-Optic+Broadband+Network+To+More+Than+50%2C000+Homes&amp;rft.date=2010-02-10&amp;rft.aulast=Schonfeld&amp;rft.aufirst=Erick&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2010%2F02%2F10%2Fgoogle-fiber-optic-network-home%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-166">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-166" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMcLaughlin2016" class="citation web cs1">McLaughlin, Kevin (August 25, 2016). <a rel="nofollow" class="external text" href="https://www.theinformation.com/articles/inside-the-battle-over-google-fiber">"Inside the Battle Over Google Fiber"</a>. <i>The Information</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161129144256/https://www.theinformation.com/articles/inside-the-battle-over-google-fiber">Archived</a> from the original on November 29, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 29,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Information&amp;rft.atitle=Inside+the+Battle+Over+Google+Fiber&amp;rft.date=2016-08-25&amp;rft.aulast=McLaughlin&amp;rft.aufirst=Kevin&amp;rft_id=https%3A%2F%2Fwww.theinformation.com%2Farticles%2Finside-the-battle-over-google-fiber&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-167">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-167" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFStatt2016" class="citation web cs1">Statt, Nick (August 25, 2016). <a rel="nofollow" class="external text" href="https://www.theverge.com/2016/8/25/12652734/google-fiber-access-alphabet-layoffs-wireless-internet">"Alphabet is putting serious pressure on Google Fiber to cut costs"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161129145849/http://www.theverge.com/2016/8/25/12652734/google-fiber-access-alphabet-layoffs-wireless-internet">Archived</a> from the original on November 29, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 29,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Alphabet+is+putting+serious+pressure+on+Google+Fiber+to+cut+costs&amp;rft.date=2016-08-25&amp;rft.aulast=Statt&amp;rft.aufirst=Nick&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2016%2F8%2F25%2F12652734%2Fgoogle-fiber-access-alphabet-layoffs-wireless-internet&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-168">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-168" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFFox2015" class="citation web cs1">Fox, Nick (April 22, 2015). <a rel="nofollow" class="external text" href="https://googleblog.blogspot.no/2015/04/project-fi.html">"Say hi to Fi: A new way to say hello"</a>. <i>Official Google Blog</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161129150714/https://googleblog.blogspot.no/2015/04/project-fi.html">Archived</a> from the original on November 29, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 29,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Official+Google+Blog&amp;rft.atitle=Say+hi+to+Fi%3A+A+new+way+to+say+hello&amp;rft.date=2015-04-22&amp;rft.aulast=Fox&amp;rft.aufirst=Nick&amp;rft_id=https%3A%2F%2Fgoogleblog.blogspot.no%2F2015%2F04%2Fproject-fi.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-169">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-169" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGoldman2015" class="citation web cs1">Goldman, David (April 22, 2015). <a rel="nofollow" class="external text" href="https://money.cnn.com/2015/04/22/technology/google-project-fi-wireless-service/">"Google launches 'Project Fi' wireless service"</a>. <i><a href="/wiki/CNN" title="CNN">CNN</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161129150255/http://money.cnn.com/2015/04/22/technology/google-project-fi-wireless-service/">Archived</a> from the original on November 29, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 29,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=CNN&amp;rft.atitle=Google+launches+%27Project+Fi%27+wireless+service&amp;rft.date=2015-04-22&amp;rft.aulast=Goldman&amp;rft.aufirst=David&amp;rft_id=https%3A%2F%2Fmoney.cnn.com%2F2015%2F04%2F22%2Ftechnology%2Fgoogle-project-fi-wireless-service%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-170">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-170" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHuet2015" class="citation web cs1">Huet, Ellen (April 22, 2015). <a rel="nofollow" class="external text" href="https://www.forbes.com/sites/ellenhuet/2015/04/22/google-unveils-wireless-service-project-fi/">"Google Unveils Its 'Project Fi' Wireless Service"</a>. <i><a href="/wiki/Forbes" title="Forbes">Forbes</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161129152041/http://www.forbes.com/sites/ellenhuet/2015/04/22/google-unveils-wireless-service-project-fi/">Archived</a> from the original on November 29, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 29,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Forbes&amp;rft.atitle=Google+Unveils+Its+%27Project+Fi%27+Wireless+Service&amp;rft.date=2015-04-22&amp;rft.aulast=Huet&amp;rft.aufirst=Ellen&amp;rft_id=https%3A%2F%2Fwww.forbes.com%2Fsites%2Fellenhuet%2F2015%2F04%2F22%2Fgoogle-unveils-wireless-service-project-fi%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-171">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-171" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFByford2016" class="citation web cs1">Byford, Sam (September 27, 2016). <a rel="nofollow" class="external text" href="https://www.theverge.com/2016/9/27/13070922/google-station-public-wi-fi-india">"Google Station is a new platform that aims to make public Wi-Fi better"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161023203300/http://www.theverge.com/2016/9/27/13070922/google-station-public-wi-fi-india">Archived</a> from the original on October 23, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">October 23,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+Station+is+a+new+platform+that+aims+to+make+public+Wi-Fi+better&amp;rft.date=2016-09-27&amp;rft.aulast=Byford&amp;rft.aufirst=Sam&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2016%2F9%2F27%2F13070922%2Fgoogle-station-public-wi-fi-india&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-172">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-172" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHeater2016" class="citation web cs1">Heater, Brian (December 29, 2016). <a rel="nofollow" class="external text" href="https://techcrunch.com/2016/12/29/google-india-wifi/">"After arriving at 100th railway station in India, Google's WiFi is set to hit another 100 in 2017"</a>. <i><a href="/wiki/TechCrunch" title="TechCrunch">TechCrunch</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170510091945/https://techcrunch.com/2016/12/29/google-india-wifi/">Archived</a> from the original on May 10, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=After+arriving+at+100th+railway+station+in+India%2C+Google%27s+WiFi+is+set+to+hit+another+100+in+2017&amp;rft.date=2016-12-29&amp;rft.aulast=Heater&amp;rft.aufirst=Brian&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2016%2F12%2F29%2Fgoogle-india-wifi%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-173">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-173" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHall2017" class="citation web cs1">Hall, Stephen (February 9, 2017). <a rel="nofollow" class="external text" href="https://9to5google.com/2017/02/09/google-station-expands-beyond-rail-stations-to-bring-citywide-wifi-to-pune-india/">"Google Station expands beyond rail stations to bring citywide WiFi to Pune, India"</a>. <i>9to5Google</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170210233838/https://9to5google.com/2017/02/09/google-station-expands-beyond-rail-stations-to-bring-citywide-wifi-to-pune-india/">Archived</a> from the original on February 10, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=9to5Google&amp;rft.atitle=Google+Station+expands+beyond+rail+stations+to+bring+citywide+WiFi+to+Pune%2C+India&amp;rft.date=2017-02-09&amp;rft.aulast=Hall&amp;rft.aufirst=Stephen&amp;rft_id=https%3A%2F%2F9to5google.com%2F2017%2F02%2F09%2Fgoogle-station-expands-beyond-rail-stations-to-bring-citywide-wifi-to-pune-india%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-174">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-174" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSingh2017" class="citation web cs1">Singh, Manish (February 9, 2017). <a rel="nofollow" class="external text" href="http://mashable.com/2017/02/09/google-station-pune-india/">"Indian city to become the first in the world to get Google Station public Wi-Fi network"</a>. <i><a href="/wiki/Mashable" title="Mashable">Mashable</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170223153245/http://mashable.com/2017/02/09/google-station-pune-india/">Archived</a> from the original on February 23, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 12,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Mashable&amp;rft.atitle=Indian+city+to+become+the+first+in+the+world+to+get+Google+Station+public+Wi-Fi+network&amp;rft.date=2017-02-09&amp;rft.aulast=Singh&amp;rft.aufirst=Manish&amp;rft_id=http%3A%2F%2Fmashable.com%2F2017%2F02%2F09%2Fgoogle-station-pune-india%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-175">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-175" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBernard2011" class="citation news cs1">Bernard, Tara (May 26, 2011). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2011/05/27/technology/27google.html">"Google Unveils App for Paying With Phone"</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161012171341/http://www.nytimes.com/2011/05/27/technology/27google.html">Archived</a> from the original on October 12, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 29,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=Google+Unveils+App+for+Paying+With+Phone&amp;rft.date=2011-05-26&amp;rft.aulast=Bernard&amp;rft.aufirst=Tara&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2011%2F05%2F27%2Ftechnology%2F27google.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-176">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-176" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSomerville2013" class="citation news cs1">Somerville, Heather (September 25, 2013). <a rel="nofollow" class="external text" href="http://www.mercurynews.com/business/ci_24171776/exclusive-google-same-day-delivery-makes-public-debut">"Google same-day delivery makes public debut"</a>. <i>Mercury News</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20131001221830/http://www.mercurynews.com/business/ci_24171776/exclusive-google-same-day-delivery-makes-public-debut">Archived</a> from the original on October 1, 2013<span class="reference-accessdate">. Retrieved <span class="nowrap">October 6,</span> 2013</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Mercury+News&amp;rft.atitle=Google+same-day+delivery+makes+public+debut&amp;rft.date=2013-09-25&amp;rft.aulast=Somerville&amp;rft.aufirst=Heather&amp;rft_id=http%3A%2F%2Fwww.mercurynews.com%2Fbusiness%2Fci_24171776%2Fexclusive-google-same-day-delivery-makes-public-debut&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-177">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-177" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHancock2007" class="citation news cs1">Hancock, Jay (October 31, 2007). <a rel="nofollow" class="external text" href="http://weblogs.baltimoresun.com/business/hancock/blog/2007/10/google_shares_hit_700.html">"Google shares hit $700"</a>. <i>The Baltimore Sun</i>. <a rel="nofollow" class="external text" href="https://www.webcitation.org/659XVy0yM?url=http://weblogs.baltimoresun.com/business/hancock/blog/2007/10/google_shares_hit_700.html">Archived</a> from the original on February 2, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">November 27,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Baltimore+Sun&amp;rft.atitle=Google+shares+hit+%24700&amp;rft.date=2007-10-31&amp;rft.aulast=Hancock&amp;rft.aufirst=Jay&amp;rft_id=http%3A%2F%2Fweblogs.baltimoresun.com%2Fbusiness%2Fhancock%2Fblog%2F2007%2F10%2Fgoogle_shares_hit_700.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-bowlingforgoogle-178">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-bowlingforgoogle_178-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-bowlingforgoogle_178-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLa_Monica2005" class="citation news cs1">La Monica, Paul R. (May 25, 2005). <a rel="nofollow" class="external text" href="https://money.cnn.com/2005/05/25/technology/techinvestor/lamonica/index.htm">"Bowling for Google"</a>. <i>CNN</i>. <a rel="nofollow" class="external text" href="https://www.webcitation.org/659XXqofq?url=http://money.cnn.com/2005/05/25/technology/techinvestor/lamonica/index.htm">Archived</a> from the original on February 2, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">February 28,</span> 2007</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=CNN&amp;rft.atitle=Bowling+for+Google&amp;rft.date=2005-05-25&amp;rft.aulast=La+Monica&amp;rft.aufirst=Paul+R.&amp;rft_id=https%3A%2F%2Fmoney.cnn.com%2F2005%2F05%2F25%2Ftechnology%2Ftechinvestor%2Flamonica%2Findex.htm&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-179">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-179" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.cnbc.com/2015/04/02/stock-split-could-cost-google-over-500-million.html">"This could cost Google more than $500 million"</a>. <i>CNBC</i>. April 2, 2015. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20151226080454/https://www.cnbc.com/2015/04/02/stock-split-could-cost-google-over-500-million.html">Archived</a> from the original on December 26, 2015<span class="reference-accessdate">. Retrieved <span class="nowrap">December 30,</span> 2015</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=CNBC&amp;rft.atitle=This+could+cost+Google+more+than+%24500+million&amp;rft.date=2015-04-02&amp;rft_id=https%3A%2F%2Fwww.cnbc.com%2F2015%2F04%2F02%2Fstock-split-could-cost-google-over-500-million.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-180">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-180" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFPramuk2015" class="citation news cs1">Pramuk, Jacob (August 10, 2015). <a rel="nofollow" class="external text" href="https://www.cnbc.com/2015/08/10/google-announces-plans-for-new-operating-structure.html">"Google to become part of new company, Alphabet"</a>. <i><a href="/wiki/CNBC" title="CNBC">CNBC</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20150811000128/https://www.cnbc.com/2015/08/10/google-announces-plans-for-new-operating-structure.html">Archived</a> from the original on August 11, 2015<span class="reference-accessdate">. Retrieved <span class="nowrap">August 11,</span> 2015</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=CNBC&amp;rft.atitle=Google+to+become+part+of+new+company%2C+Alphabet&amp;rft.date=2015-08-10&amp;rft.aulast=Pramuk&amp;rft.aufirst=Jacob&amp;rft_id=https%3A%2F%2Fwww.cnbc.com%2F2015%2F08%2F10%2Fgoogle-announces-plans-for-new-operating-structure.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-181">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-181" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFVise2005" class="citation news cs1">Vise, David (October 21, 2005). <a rel="nofollow" class="external text" href="https://www.washingtonpost.com/wp-dyn/content/article/2005/10/20/AR2005102002058.html">"Online Ads Give Google Huge Gain in Profit"</a>. <i><a href="/wiki/The_Washington_Post" title="The Washington Post">The Washington Post</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161020134416/http://www.washingtonpost.com/wp-dyn/content/article/2005/10/20/AR2005102002058.html">Archived</a> from the original on October 20, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 27,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Washington+Post&amp;rft.atitle=Online+Ads+Give+Google+Huge+Gain+in+Profit&amp;rft.date=2005-10-21&amp;rft.aulast=Vise&amp;rft.aufirst=David&amp;rft_id=https%3A%2F%2Fwww.washingtonpost.com%2Fwp-dyn%2Fcontent%2Farticle%2F2005%2F10%2F20%2FAR2005102002058.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-182">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-182" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLa_Monica2005" class="citation news cs1">La Monica, Paul R. (October 21, 2005). <a rel="nofollow" class="external text" href="https://money.cnn.com/2005/10/20/technology/google_analysis/index.htm">"All signals go for Google"</a>. <i><a href="/wiki/CNN" title="CNN">CNN</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=CNN&amp;rft.atitle=All+signals+go+for+Google&amp;rft.date=2005-10-21&amp;rft.aulast=La+Monica&amp;rft.aufirst=Paul+R.&amp;rft_id=https%3A%2F%2Fmoney.cnn.com%2F2005%2F10%2F20%2Ftechnology%2Fgoogle_analysis%2Findex.htm&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-183">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-183" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="https://www.cbc.ca/amp/1.558678">"Google shares jump on big profit increase"</a>. <i><a href="/wiki/CBC_News" title="CBC News">CBC News</a></i>. October 21, 2005.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=CBC+News&amp;rft.atitle=Google+shares+jump+on+big+profit+increase&amp;rft.date=2005-10-21&amp;rft_id=https%3A%2F%2Fwww.cbc.ca%2Famp%2F1.558678&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-10-K-184">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-10-K_184-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.sec.gov/Archives/edgar/data/1288776/000119312507044494/d10k.htm">"Form 10-K<span class="nowrap">&nbsp;</span>– Annual Report"</a>. SEC. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20101106152355/http://www.sec.gov/Archives/edgar/data/1288776/000119312507044494/d10k.htm">Archived</a> from the original on November 6, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">July 5,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Form+10-K%3Cspan+class%3D%22nowrap%22%3E+%3C%2Fspan%3E%E2%80%93+Annual+Report&amp;rft.pub=SEC&amp;rft_id=https%3A%2F%2Fwww.sec.gov%2FArchives%2Fedgar%2Fdata%2F1288776%2F000119312507044494%2Fd10k.htm&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-Google-Inc-Jan-2012-10-K-185">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-Google-Inc-Jan-2012-10-K_185-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://pdf.secdatabase.com/44/0001193125-12-025336.pdf">"Google Inc, Form 10-K, Annual Report, Filing Date January 26, 2012"</a> <span class="cs1-format">(PDF)</span>. secdatabase.com. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20130502193637/http://pdf.secdatabase.com/44/0001193125-12-025336.pdf">Archived</a> <span class="cs1-format">(PDF)</span> from the original on May 2, 2013<span class="reference-accessdate">. Retrieved <span class="nowrap">March 8,</span> 2013</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google+Inc%2C+Form+10-K%2C+Annual+Report%2C+Filing+Date+January+26%2C+2012&amp;rft.pub=secdatabase.com&amp;rft_id=http%3A%2F%2Fpdf.secdatabase.com%2F44%2F0001193125-12-025336.pdf&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-186">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-186" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFFiegerman2013" class="citation web cs1">Fiegerman, Seth (January 22, 2013). <a rel="nofollow" class="external text" href="http://mashable.com/2013/01/22/google-q4-earnings/#42cbeRCbSkqH">"Google Has Its First $50 Billion Year"</a>. <i><a href="/wiki/Mashable" title="Mashable">Mashable</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161201014741/http://mashable.com/2013/01/22/google-q4-earnings/#42cbeRCbSkqH">Archived</a> from the original on December 1, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">November 30,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Mashable&amp;rft.atitle=Google+Has+Its+First+%2450+Billion+Year&amp;rft.date=2013-01-22&amp;rft.aulast=Fiegerman&amp;rft.aufirst=Seth&amp;rft_id=http%3A%2F%2Fmashable.com%2F2013%2F01%2F22%2Fgoogle-q4-earnings%2F%2342cbeRCbSkqH&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-187">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-187" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWhitwam2013" class="citation web cs1">Whitwam, Ryan (October 18, 2013). <a rel="nofollow" class="external text" href="http://www.androidpolice.com/2013/10/18/google-beats-analyst-estimates-for-third-quarter-results-stock-passes-1000-per-share/">"Google Beats Analyst Estimates For Third Quarter Results, Stock Passes $1000 Per Share"</a>. <i>Android Police</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170316025733/http://www.androidpolice.com/2013/10/18/google-beats-analyst-estimates-for-third-quarter-results-stock-passes-1000-per-share/">Archived</a> from the original on March 16, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 15,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Android+Police&amp;rft.atitle=Google+Beats+Analyst+Estimates+For+Third+Quarter+Results%2C+Stock+Passes+%241000+Per+Share&amp;rft.date=2013-10-18&amp;rft.aulast=Whitwam&amp;rft.aufirst=Ryan&amp;rft_id=http%3A%2F%2Fwww.androidpolice.com%2F2013%2F10%2F18%2Fgoogle-beats-analyst-estimates-for-third-quarter-results-stock-passes-1000-per-share%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-188">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-188" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/20131017221536/http://www.theguardian.com/technology/2013/oct/17/google-q3-revenue-earnings-report">"Google earnings up 12% in third quarter even as Motorola losses deepen"</a>. <i>The Guardian</i>. Reuters. October 17, 2013. Archived from <a rel="nofollow" class="external text" href="https://www.theguardian.com/technology/2013/oct/17/google-q3-revenue-earnings-report">the original</a> on October 17, 2013<span class="reference-accessdate">. Retrieved <span class="nowrap">October 18,</span> 2013</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Guardian&amp;rft.atitle=Google+earnings+up+12%25+in+third+quarter+even+as+Motorola+losses+deepen&amp;rft.date=2013-10-17&amp;rft_id=https%3A%2F%2Fwww.theguardian.com%2Ftechnology%2F2013%2Foct%2F17%2Fgoogle-q3-revenue-earnings-report&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-Marketwatch-189">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-Marketwatch_189-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://www.marketwatch.com/investing/stock/goog">"Google Overview"</a>. <i>Marketwatch</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20140202073406/http://www.marketwatch.com/investing/stock/GOOG">Archived</a> from the original on February 2, 2014<span class="reference-accessdate">. Retrieved <span class="nowrap">February 2,</span> 2014</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Marketwatch&amp;rft.atitle=Google+Overview&amp;rft_id=http%3A%2F%2Fwww.marketwatch.com%2Finvesting%2Fstock%2Fgoog&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-190">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-190" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMetz2010" class="citation web cs1">Metz, Cade (October 22, 2010). <a rel="nofollow" class="external text" href="https://www.theregister.co.uk/2010/10/22/google_double_irish_tax_loophole/">"Google slips $3.1bn through 'Double Irish' tax loophole"</a>. <i>The Register</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170706132414/https://www.theregister.co.uk/2010/10/22/google_double_irish_tax_loophole/">Archived</a> from the original on July 6, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">August 10,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Register&amp;rft.atitle=Google+slips+%243.1bn+through+%27Double+Irish%27+tax+loophole.&amp;rft.date=2010-10-22&amp;rft.aulast=Metz&amp;rft.aufirst=Cade&amp;rft_id=https%3A%2F%2Fwww.theregister.co.uk%2F2010%2F10%2F22%2Fgoogle_double_irish_tax_loophole%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-191">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-191" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLeach2012" class="citation web cs1">Leach, Anna (October 31, 2012). <a rel="nofollow" class="external text" href="https://www.theregister.co.uk/2012/10/31/google_france_tax_office_billion_euros/">"French gov 'plans to hand Google €1bn tax bill'&nbsp;– report"</a>. Theregister.co.uk. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20130104002014/http://www.theregister.co.uk/2012/10/31/google_france_tax_office_billion_euros/">Archived</a> from the original on January 4, 2013<span class="reference-accessdate">. Retrieved <span class="nowrap">January 2,</span> 2013</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=French+gov+%27plans+to+hand+Google+%E2%82%AC1bn+tax+bill%27+%E2%80%93+report&amp;rft.pub=Theregister.co.uk&amp;rft.date=2012-10-31&amp;rft.aulast=Leach&amp;rft.aufirst=Anna&amp;rft_id=https%3A%2F%2Fwww.theregister.co.uk%2F2012%2F10%2F31%2Fgoogle_france_tax_office_billion_euros%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-192">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-192" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWaters2020" class="citation news cs1">Waters, Richard (January 2, 2020). <span class="cs1-lock-subscription" title="Paid subscription required"><a rel="nofollow" class="external text" href="https://www.ft.com/content/991f11ae-2c51-11ea-bc77-65e4aa615551">"Google to end use of 'double Irish' as tax loophole set to close"</a></span>. <i><a href="/wiki/Financial_Times" title="Financial Times">Financial Times</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Financial+Times&amp;rft.atitle=Google+to+end+use+of+%27double+Irish%27+as+tax+loophole+set+to+close&amp;rft.date=2020-01-02&amp;rft.aulast=Waters&amp;rft.aufirst=Richard&amp;rft_id=https%3A%2F%2Fwww.ft.com%2Fcontent%2F991f11ae-2c51-11ea-bc77-65e4aa615551&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-193">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-193" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBrid-Aine_Parnell2013" class="citation web cs1">Brid-Aine Parnell (May 17, 2013). <a rel="nofollow" class="external text" href="https://www.theregister.co.uk/2013/05/17/quotw_ending_may_17/">"I think you DO do evil, using smoke and mirrors to avoid tax"</a>. Theregister.co.uk. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20131226090028/http://www.theregister.co.uk/2013/05/17/quotw_ending_may_17/">Archived</a> from the original on December 26, 2013<span class="reference-accessdate">. Retrieved <span class="nowrap">March 13,</span> 2014</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=I+think+you+DO+do+evil%2C+using+smoke+and+mirrors+to+avoid+tax&amp;rft.pub=Theregister.co.uk&amp;rft.date=2013-05-17&amp;rft.au=Brid-Aine+Parnell&amp;rft_id=https%3A%2F%2Fwww.theregister.co.uk%2F2013%2F05%2F17%2Fquotw_ending_may_17%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-194">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-194" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFJohn_Gapper2016" class="citation web cs1">John Gapper (January 23, 2016). <a rel="nofollow" class="external text" href="https://www.ft.com/cms/s/0/d50ad5f4-c125-11e5-9fdb-87b8d15baec2.html">"Google strikes £130m back tax deal"</a>. FT.com. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20160124195612/http://www.ft.com/cms/s/0/d50ad5f4-c125-11e5-9fdb-87b8d15baec2.html">Archived</a> from the original on January 24, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">January 24,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google+strikes+%C2%A3130m+back+tax+deal&amp;rft.pub=FT.com&amp;rft.date=2016-01-23&amp;rft.au=John+Gapper&amp;rft_id=http%3A%2F%2Fwww.ft.com%2Fcms%2Fs%2F0%2Fd50ad5f4-c125-11e5-9fdb-87b8d15baec2.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-195">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-195" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBart_Meijer2019" class="citation news cs1">Bart Meijer (January 3, 2019). <a rel="nofollow" class="external text" href="https://www.reuters.com/article/us-google-taxes-netherlands/google-shifted-23-billion-to-tax-haven-bermuda-in-2017-filing-idUSKCN1OX1G9">"Google shifted $23 billion to tax haven Bermuda in 2017: filing"</a>. <i>Reuters</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190103215930/https://www.reuters.com/article/us-google-taxes-netherlands/google-shifted-23-billion-to-tax-haven-bermuda-in-2017-filing-idUSKCN1OX1G9">Archived</a> from the original on January 3, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">January 3,</span> 2019</span>. <q>Google moved 19.9 billion euros ($22.7 billion) through a Dutch shell company to Bermuda in 2017, as part of an arrangement that allows it to reduce its foreign tax bill</q></cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Reuters&amp;rft.atitle=Google+shifted+%2423+billion+to+tax+haven+Bermuda+in+2017%3A+filing&amp;rft.date=2019-01-03&amp;rft.au=Bart+Meijer&amp;rft_id=https%3A%2F%2Fwww.reuters.com%2Farticle%2Fus-google-taxes-netherlands%2Fgoogle-shifted-23-billion-to-tax-haven-bermuda-in-2017-filing-idUSKCN1OX1G9&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-lobby1-196">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-lobby1_196-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHamburgerGold2014" class="citation news cs1">Hamburger, Tom; Gold, Matea (April 13, 2014). <a rel="nofollow" class="external text" href="https://www.washingtonpost.com/politics/how-google-is-transforming-power-and-politicsgoogle-once-disdainful-of-lobbying-now-a-master-of-washington-influence/2014/04/12/51648b92-b4d3-11e3-8cb6-284052554d74_story.html">"Google, once disdainful of lobbying, now a master of Washington influence"</a>. <i><a href="/wiki/The_Washington_Post" title="The Washington Post">The Washington Post</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20171027124925/https://www.washingtonpost.com/politics/how-google-is-transforming-power-and-politicsgoogle-once-disdainful-of-lobbying-now-a-master-of-washington-influence/2014/04/12/51648b92-b4d3-11e3-8cb6-284052554d74_story.html">Archived</a> from the original on October 27, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">August 22,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Washington+Post&amp;rft.atitle=Google%2C+once+disdainful+of+lobbying%2C+now+a+master+of+Washington+influence&amp;rft.date=2014-04-13&amp;rft.aulast=Hamburger&amp;rft.aufirst=Tom&amp;rft.au=Gold%2C+Matea&amp;rft_id=https%3A%2F%2Fwww.washingtonpost.com%2Fpolitics%2Fhow-google-is-transforming-power-and-politicsgoogle-once-disdainful-of-lobbying-now-a-master-of-washington-influence%2F2014%2F04%2F12%2F51648b92-b4d3-11e3-8cb6-284052554d74_story.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-197"><span class="mw-cite-backlink"><b><a href="#cite_ref-197" aria-label="Jump up" title="Jump up">^</a></b></span> <span class="reference-text">Koller, David. "<a rel="nofollow" class="external text" href="http://graphics.stanford.edu/~dk/google_name_origin.html">Origin of the name, "Google."</a> <a rel="nofollow" class="external text" href="https://www.webcitation.org/68ubHzYs7?url=http://graphics.stanford.edu/~dk/google_name_origin.html">Archived</a> 2012-07-04 at <a href="/wiki/WebCite" title="WebCite">WebCite</a> <i><a href="/wiki/Stanford_University" title="Stanford University">Stanford University</a>.</i> January, 2004.</span></li>
            <li id="cite_note-Hanley-198"><span class="mw-cite-backlink"><b><a href="#cite_ref-Hanley_198-0" aria-label="Jump up" title="Jump up">^</a></b></span> <span class="reference-text">Hanley, Rachael. "<a rel="nofollow" class="external text" href="http://www.stanforddaily.com/2003/02/12/from-googol-to-google/">From Googol to Google: Co-founder returns</a> <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100330004631/http://www.stanforddaily.com/2003/02/12/from-googol-to-google/">Archived</a> March 30, 2010, at the <a href="/wiki/Wayback_Machine" title="Wayback Machine">Wayback Machine</a>." <i><a href="/wiki/The_Stanford_Daily" title="The Stanford Daily">The Stanford Daily</a>.</i> February 12, 2003. Retrieved on August 26, 2010.</span></li>
            <li id="cite_note-199">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-199" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHarris2006" class="citation news cs1">Harris, Scott D. (July 7, 2006). <a rel="nofollow" class="external text" href="https://web.archive.org/web/20070206065348/http://www.mercurynews.com/mld/mercurynews/business/14985574.htm">"Dictionary adds verb: to google"</a>. <i>San Jose Mercury News</i>. Archived from <a rel="nofollow" class="external text" href="http://www.mercurynews.com/mld/mercurynews/business/14985574.htm">the original</a> on February 6, 2007<span class="reference-accessdate">. Retrieved <span class="nowrap">July 7,</span> 2006</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=San+Jose+Mercury+News&amp;rft.atitle=Dictionary+adds+verb%3A+to+google&amp;rft.date=2006-07-07&amp;rft.aulast=Harris&amp;rft.aufirst=Scott+D.&amp;rft_id=http%3A%2F%2Fwww.mercurynews.com%2Fmld%2Fmercurynews%2Fbusiness%2F14985574.htm&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-200">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-200" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBylund2006" class="citation news cs1">Bylund, Anders (July 5, 2006). <a rel="nofollow" class="external text" href="https://archive.today/20060707062623/http://msnbc.msn.com/id/13720643/">"To Google or Not to Google"</a>. <i><a href="/wiki/The_Motley_Fool" title="The Motley Fool">The Motley Fool</a></i>. Archived from <a rel="nofollow" class="external text" href="http://msnbc.msn.com/id/13720643/">the original</a> on July 7, 2006<span class="reference-accessdate">. Retrieved <span class="nowrap">July 7,</span> 2006</span> – via <a href="/wiki/MSNBC" title="MSNBC">MSNBC</a>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Motley+Fool&amp;rft.atitle=To+Google+or+Not+to+Google&amp;rft.date=2006-07-05&amp;rft.aulast=Bylund&amp;rft.aufirst=Anders&amp;rft_id=http%3A%2F%2Fmsnbc.msn.com%2Fid%2F13720643%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-201">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-201" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGibbs2014" class="citation web cs1">Gibbs, Samuel (November 3, 2014). <a rel="nofollow" class="external text" href="https://www.theguardian.com/technology/2014/nov/03/larry-page-google-dont-be-evil-sergey-brin">"Google has 'outgrown' its 14-year old mission statement, says Larry Page"</a>. <i><a href="/wiki/The_Guardian" title="The Guardian">The Guardian</a></i>. <a href="/wiki/Guardian_Media_Group" title="Guardian Media Group">Guardian Media Group</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170326053031/https://www.theguardian.com/technology/2014/nov/03/larry-page-google-dont-be-evil-sergey-brin">Archived</a> from the original on March 26, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 25,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Guardian&amp;rft.atitle=Google+has+%27outgrown%27+its+14-year+old+mission+statement%2C+says+Larry+Page&amp;rft.date=2014-11-03&amp;rft.aulast=Gibbs&amp;rft.aufirst=Samuel&amp;rft_id=https%3A%2F%2Fwww.theguardian.com%2Ftechnology%2F2014%2Fnov%2F03%2Flarry-page-google-dont-be-evil-sergey-brin&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-202">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-202" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://abc.xyz/investor/other/google-code-of-conduct.html">"Google Code of Conduct"</a>. <i>Alphabet Investor Relations</i>. <a href="/wiki/Alphabet_Inc." title="Alphabet Inc.">Alphabet Inc.</a> April 11, 2012. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170211223917/https://abc.xyz/investor/other/google-code-of-conduct.html">Archived</a> from the original on February 11, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 25,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Alphabet+Investor+Relations&amp;rft.atitle=Google+Code+of+Conduct&amp;rft.date=2012-04-11&amp;rft_id=https%3A%2F%2Fabc.xyz%2Finvestor%2Fother%2Fgoogle-code-of-conduct.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-203">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-203" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLawler2015" class="citation web cs1">Lawler, Richard (October 2, 2015). <a rel="nofollow" class="external text" href="https://www.engadget.com/2015/10/02/alphabet-do-the-right-thing/">"Alphabet replaces Google's 'Don't be evil' with 'Do the right thing<span class="cs1-kern-right">'</span>"</a>. <i><a href="/wiki/Engadget" title="Engadget">Engadget</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170701225925/https://www.engadget.com/2015/10/02/alphabet-do-the-right-thing/">Archived</a> from the original on July 1, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 25,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Engadget&amp;rft.atitle=Alphabet+replaces+Google%27s+%27Don%27t+be+evil%27+with+%27Do+the+right+thing%27&amp;rft.date=2015-10-02&amp;rft.aulast=Lawler&amp;rft.aufirst=Richard&amp;rft_id=https%3A%2F%2Fwww.engadget.com%2F2015%2F10%2F02%2Falphabet-do-the-right-thing%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-204">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-204" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="http://www.ndtv.com/photos/news/happy-birthday-google--8267#photo-99345">"Happy Birthday Google!"</a>. ndtv.com. NDTV Convergence Limited. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190407042748/https://www.ndtv.com/photos/news/happy-birthday-google--8267#photo-99345">Archived</a> from the original on April 7, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">April 28,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Happy+Birthday+Google%21&amp;rft_id=http%3A%2F%2Fwww.ndtv.com%2Fphotos%2Fnews%2Fhappy-birthday-google--8267%23photo-99345&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-205">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-205" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/doodle4google/history.html">"Doodle 4 Google"</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20140427143948/http://www.google.com/doodle4google/history.html">Archived</a> from the original on April 27, 2014<span class="reference-accessdate">. Retrieved <span class="nowrap">April 23,</span> 2014</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Doodle+4+Google&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fdoodle4google%2Fhistory.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-206">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-206" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/doodles/burning-man-festival">"Burning Man Festival"</a>. August 30, 1998. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20140425051111/https://www.google.com/doodles/burning-man-festival">Archived</a> from the original on April 25, 2014<span class="reference-accessdate">. Retrieved <span class="nowrap">April 23,</span> 2014</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Burning+Man+Festival&amp;rft.date=1998-08-30&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fdoodles%2Fburning-man-festival&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-207">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-207" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="https://www.theguardian.com/technology/2014/apr/12/meet-people-behind-google-doodles-logo">"Meet the people behind the Google Doodles"</a>. <i>The Guardian</i>. April 12, 2014. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20141006222909/http://www.theguardian.com/technology/2014/apr/12/meet-people-behind-google-doodles-logo">Archived</a> from the original on October 6, 2014<span class="reference-accessdate">. Retrieved <span class="nowrap">September 27,</span> 2014</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Guardian&amp;rft.atitle=Meet+the+people+behind+the+Google+Doodles&amp;rft.date=2014-04-12&amp;rft_id=https%3A%2F%2Fwww.theguardian.com%2Ftechnology%2F2014%2Fapr%2F12%2Fmeet-people-behind-google-doodles-logo&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-mentalplex-208">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-mentalplex_208-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/mentalplex/">"Google MentalPlex"</a>. Google, Inc. April 1, 2000. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100921223048/http://www.google.com/mentalplex/">Archived</a> from the original on September 21, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">July 5,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google+MentalPlex&amp;rft.pub=Google%2C+Inc.&amp;rft.date=2000-04-01&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fmentalplex%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-TiSP-209">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-TiSP_209-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/tisp/">"Welcome to Google TiSP"</a>. Google, Inc. April 1, 2007. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100709034300/http://www.google.com/tisp/">Archived</a> from the original on July 9, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">July 5,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Welcome+to+Google+TiSP&amp;rft.pub=Google%2C+Inc.&amp;rft.date=2007-04-01&amp;rft_id=https%3A%2F%2Fwww.google.com%2Ftisp%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-210">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-210" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.webcitation.org/5hT77QDRS?url=http://www.google.com/language_tools">"Language Tools"</a>. Google, Inc. Archived from <a rel="nofollow" class="external text" href="https://www.google.com/language_tools">the original</a> on June 12, 2009<span class="reference-accessdate">. Retrieved <span class="nowrap">July 4,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Language+Tools&amp;rft.pub=Google%2C+Inc.&amp;rft_id=https%3A%2F%2Fwww.google.com%2Flanguage_tools&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-211">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-211" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/search?q=anagram">"anagram search"</a>. Google, Inc. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20130624205429/http://www.google.com/search?q=anagram">Archived</a> from the original on June 24, 2013<span class="reference-accessdate">. Retrieved <span class="nowrap">September 22,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=anagram+search&amp;rft.pub=Google%2C+Inc.&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fsearch%3Fq%3Danagram&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-best_company-212">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-best_company_212-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLeveringMoskowitz2007" class="citation journal cs1">Levering, Robert; Moskowitz, Milton (January 22, 2007).  <a href="/wiki/Andrew_Serwer" title="Andrew Serwer">Serwer, Andrew</a> (ed.). <a rel="nofollow" class="external text" href="https://money.cnn.com/magazines/fortune/fortune_archive/2007/01/22/8398125/index.htm">"In good company"</a>. <i>Fortune Magazine</i>. <b>155</b> (1): 94–6, 100, 102 passim. <a href="/wiki/PMID_(identifier)" class="mw-redirect" title="PMID (identifier)">PMID</a>&nbsp;<a rel="nofollow" class="external text" href="//pubmed.ncbi.nlm.nih.gov/17256628">17256628</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100301175257/http://money.cnn.com/magazines/fortune/fortune_archive/2007/01/22/8398125/index.htm">Archived</a> from the original on March 1, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">June 19,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Fortune+Magazine&amp;rft.atitle=In+good+company&amp;rft.volume=155&amp;rft.issue=1&amp;rft.pages=94-6%2C+100%2C+102+passim&amp;rft.date=2007-01-22&amp;rft_id=info%3Apmid%2F17256628&amp;rft.aulast=Levering&amp;rft.aufirst=Robert&amp;rft.au=Moskowitz%2C+Milton&amp;rft_id=https%3A%2F%2Fmoney.cnn.com%2Fmagazines%2Ffortune%2Ffortune_archive%2F2007%2F01%2F22%2F8398125%2Findex.htm&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-213">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-213" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLeveringMoskowitz2008" class="citation journal cs1">Levering, Robert; Moskowitz, Milton (February 4, 2008).  <a href="/wiki/Andrew_Serwer" title="Andrew Serwer">Serwer, Andrew</a> (ed.). <a rel="nofollow" class="external text" href="https://money.cnn.com/magazines/fortune/bestcompanies/2008/full_list/index.html">"The 2008 list"</a>. <i>Fortune Magazine</i>. <b>157</b> (2). <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100723223729/http://money.cnn.com/magazines/fortune/bestcompanies/2008/full_list/index.html">Archived</a> from the original on July 23, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">June 19,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Fortune+Magazine&amp;rft.atitle=The+2008+list&amp;rft.volume=157&amp;rft.issue=2&amp;rft.date=2008-02-04&amp;rft.aulast=Levering&amp;rft.aufirst=Robert&amp;rft.au=Moskowitz%2C+Milton&amp;rft_id=https%3A%2F%2Fmoney.cnn.com%2Fmagazines%2Ffortune%2Fbestcompanies%2F2008%2Ffull_list%2Findex.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-214">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-214" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation journal cs1"><a rel="nofollow" class="external text" href="https://money.cnn.com/magazines/fortune/best-companies/2012/full_list/">"The 2012 list"</a>. <i>Fortune Magazine</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20121031135647/http://money.cnn.com/magazines/fortune/best-companies/2012/full_list/">Archived</a> from the original on October 31, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">February 26,</span> 2012</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Fortune+Magazine&amp;rft.atitle=The+2012+list&amp;rft_id=https%3A%2F%2Fmoney.cnn.com%2Fmagazines%2Ffortune%2Fbest-companies%2F2012%2Ffull_list%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-215">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-215" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLeveringMoskowitz2009" class="citation journal cs1">Levering, Robert; Moskowitz, Milton (February 2, 2009).  <a href="/wiki/Andrew_Serwer" title="Andrew Serwer">Serwer, Andrew</a> (ed.). <a rel="nofollow" class="external text" href="https://money.cnn.com/magazines/fortune/bestcompanies/2009/full_list/index.html">"The 2009 list"</a>. <i>Fortune Magazine</i>. <b>159</b> (2). <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100726042849/http://money.cnn.com/magazines/fortune/bestcompanies/2009/full_list/index.html">Archived</a> from the original on July 26, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">June 19,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Fortune+Magazine&amp;rft.atitle=The+2009+list&amp;rft.volume=159&amp;rft.issue=2&amp;rft.date=2009-02-02&amp;rft.aulast=Levering&amp;rft.aufirst=Robert&amp;rft.au=Moskowitz%2C+Milton&amp;rft_id=https%3A%2F%2Fmoney.cnn.com%2Fmagazines%2Ffortune%2Fbestcompanies%2F2009%2Ffull_list%2Findex.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-216">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-216" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLeveringMoskowitz2010" class="citation journal cs1">Levering, Robert; Moskowitz, Milton (February 8, 2010).  <a href="/wiki/Andrew_Serwer" title="Andrew Serwer">Serwer, Andrew</a> (ed.). <a rel="nofollow" class="external text" href="https://money.cnn.com/magazines/fortune/bestcompanies/2010/full_list/">"The 2010 list"</a>. <i>Fortune Magazine</i>. <b>161</b> (2). <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100618125312/http://money.cnn.com/magazines/fortune/bestcompanies/2010/full_list/">Archived</a> from the original on June 18, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">June 19,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Fortune+Magazine&amp;rft.atitle=The+2010+list&amp;rft.volume=161&amp;rft.issue=2&amp;rft.date=2010-02-08&amp;rft.aulast=Levering&amp;rft.aufirst=Robert&amp;rft.au=Moskowitz%2C+Milton&amp;rft_id=https%3A%2F%2Fmoney.cnn.com%2Fmagazines%2Ffortune%2Fbestcompanies%2F2010%2Ffull_list%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-217">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-217" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/20101112131208/http://www.universumglobal.com/IDEAL-Employer-Rankings/Global-Top-50">"The World's Most Attractive Employers 2010"</a>. Universum Global. September 28, 2010. Archived from <a rel="nofollow" class="external text" href="http://www.universumglobal.com/IDEAL-Employer-Rankings/Global-Top-50">the original</a> on November 12, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">October 28,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=The+World%27s+Most+Attractive+Employers+2010&amp;rft.pub=Universum+Global&amp;rft.date=2010-09-28&amp;rft_id=http%3A%2F%2Fwww.universumglobal.com%2FIDEAL-Employer-Rankings%2FGlobal-Top-50&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-218">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-218" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/corporate/tenthings.html">"Our Philosophy"</a>. Google, Inc. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100709041157/http://www.google.com/corporate/tenthings.html">Archived</a> from the original on July 9, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">June 20,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Our+Philosophy&amp;rft.pub=Google%2C+Inc.&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fcorporate%2Ftenthings.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-219">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-219" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://abc.xyz/investor/static/pdf/20201030_alphabet_10Q.pdf">"Alphabet Q3 2020 10-Q Report"</a> <span class="cs1-format">(PDF)</span>. <i>Alphabet Inc</i>. <a rel="nofollow" class="external text" href="https://archive.today/20201230042646/https://abc.xyz/investor/static/pdf/20201030_alphabet_10Q.pdf">Archived</a> <span class="cs1-format">(PDF)</span> from the original on December 30, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">December 30,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Alphabet+Inc.&amp;rft.atitle=Alphabet+Q3+2020+10-Q+Report&amp;rft_id=https%3A%2F%2Fabc.xyz%2Finvestor%2Fstatic%2Fpdf%2F20201030_alphabet_10Q.pdf&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-220">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-220" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFNievaCarson2020" class="citation web cs1">Nieva, Richard; Carson, Erin (May 5, 2020). <a rel="nofollow" class="external text" href="https://www.cnet.com/news/googles-diversity-numbers-show-incremental-progress/">"Google's diversity numbers show incremental progress"</a>. <i>CNET</i><span class="reference-accessdate">. Retrieved <span class="nowrap">January 1,</span> 2021</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=CNET&amp;rft.atitle=Google%27s+diversity+numbers+show+incremental+progress&amp;rft.date=2020-05-05&amp;rft.aulast=Nieva&amp;rft.aufirst=Richard&amp;rft.au=Carson%2C+Erin&amp;rft_id=https%3A%2F%2Fwww.cnet.com%2Fnews%2Fgoogles-diversity-numbers-show-incremental-progress%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-221">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-221" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://kstatic.googleusercontent.com/files/25badfc6b6d1b33f3b87372ff7545d79261520d821e6ee9a82c4ab2de42a01216be2156bc5a60ae3337ffe7176d90b8b2b3000891ac6e516a650ecebf0e3f866">"Google Diversity Annual Report 2020"</a>. <i>Google</i>. 2020. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20201216005455/https://kstatic.googleusercontent.com/files/25badfc6b6d1b33f3b87372ff7545d79261520d821e6ee9a82c4ab2de42a01216be2156bc5a60ae3337ffe7176d90b8b2b3000891ac6e516a650ecebf0e3f866">Archived</a> from the original on December 16, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">January 1,</span> 2021</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Google&amp;rft.atitle=Google+Diversity+Annual+Report+2020&amp;rft.date=2020&amp;rft_id=https%3A%2F%2Fkstatic.googleusercontent.com%2Ffiles%2F25badfc6b6d1b33f3b87372ff7545d79261520d821e6ee9a82c4ab2de42a01216be2156bc5a60ae3337ffe7176d90b8b2b3000891ac6e516a650ecebf0e3f866&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-222">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-222" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWakabayashi2017" class="citation news cs1">Wakabayashi, Daisuke (September 8, 2017). <a rel="nofollow" class="external text" href="https://www.cnbc.com/2017/09/08/google-gender-pay-gap-spreadsheet-finds-men-paid-more-than-women.html">"Google workers collected data showing their male colleagues make more than women"</a>. <i>CNBC</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170926095602/https://www.cnbc.com/2017/09/08/google-gender-pay-gap-spreadsheet-finds-men-paid-more-than-women.html">Archived</a> from the original on September 26, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">September 25,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=CNBC&amp;rft.atitle=Google+workers+collected+data+showing+their+male+colleagues+make+more+than+women&amp;rft.date=2017-09-08&amp;rft.aulast=Wakabayashi&amp;rft.aufirst=Daisuke&amp;rft_id=https%3A%2F%2Fwww.cnbc.com%2F2017%2F09%2F08%2Fgoogle-gender-pay-gap-spreadsheet-finds-men-paid-more-than-women.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-223">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-223" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMedirattaBick2007" class="citation web cs1">Mediratta, Bharat; Bick, Julie (October 21, 2007). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2007/10/21/jobs/21pre.html">"The Google Way: Give Engineers Room"</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170402201354/http://www.nytimes.com/2007/10/21/jobs/21pre.html">Archived</a> from the original on April 2, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 9,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=The+Google+Way%3A+Give+Engineers+Room&amp;rft.date=2007-10-21&amp;rft.aulast=Mediratta&amp;rft.aufirst=Bharat&amp;rft.au=Bick%2C+Julie&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2007%2F10%2F21%2Fjobs%2F21pre.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-224">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-224" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation audio-visual cs1">Mayer, Marissa (speaker) (June 30, 2006). <a rel="nofollow" class="external text" href="https://www.youtube.com/watch?v=soYKFWqVVzg"><i>Marissa Mayer at Stanford University</i></a> (Seminar). Martin Lafrance.  Event occurs at 11:33. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100816150501/http://www.youtube.com//watch?v=soYKFWqVVzg">Archived</a> from the original on August 16, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">June 20,</span> 2010</span>. <q>Fifty percent of what Google launched in the second half of 2005 actually got built out of 20% time.</q></cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Marissa+Mayer+at+Stanford+University&amp;rft.pub=Martin+Lafrance&amp;rft.date=2006-06-30&amp;rft_id=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DsoYKFWqVVzg&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-225">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-225" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFRivlin2005" class="citation web cs1">Rivlin, Gary (August 24, 2005). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2005/08/24/technology/relax-bill-gates-its-googles-turn-as-the-villain.html">"Relax, Bill Gates; It's Google's Turn as the Villain"</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170403014314/http://www.nytimes.com/2005/08/24/technology/relax-bill-gates-its-googles-turn-as-the-villain.html">Archived</a> from the original on April 3, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 9,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=Relax%2C+Bill+Gates%3B+It%27s+Google%27s+Turn+as+the+Villain&amp;rft.date=2005-08-24&amp;rft.aulast=Rivlin&amp;rft.aufirst=Gary&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2005%2F08%2F24%2Ftechnology%2Frelax-bill-gates-its-googles-turn-as-the-villain.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-226">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-226" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFUtz,_Richard2013" class="citation journal cs1">Utz, Richard (2013). "The Good Corporation? Google's Medievalism and Why It Matters". <i>Studies in Medievalism</i>. <b>23</b>: 21–28.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Studies+in+Medievalism&amp;rft.atitle=The+Good+Corporation%3F+Google%27s+Medievalism+and+Why+It+Matters&amp;rft.volume=23&amp;rft.pages=21-28&amp;rft.date=2013&amp;rft.au=Utz%2C+Richard&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-227">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-227" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGibsonWray2005" class="citation news cs1">Gibson, Owen; Wray, Richard (August 25, 2005). <a rel="nofollow" class="external text" href="https://www.smh.com.au/news/technology/search-giant-may-outgrow-its-fans/2005/08/25/1124562975596.html3001.asp">"Search giant may outgrow its fans"</a>. <i>The Sydney Morning Herald</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100517075346/http://www.smh.com.au/news/technology/search-giant-may-outgrow-its-fans/2005/08/25/1124562975596.html3001.asp">Archived</a> from the original on May 17, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">November 27,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Sydney+Morning+Herald&amp;rft.atitle=Search+giant+may+outgrow+its+fans&amp;rft.date=2005-08-25&amp;rft.aulast=Gibson&amp;rft.aufirst=Owen&amp;rft.au=Wray%2C+Richard&amp;rft_id=https%3A%2F%2Fwww.smh.com.au%2Fnews%2Ftechnology%2Fsearch-giant-may-outgrow-its-fans%2F2005%2F08%2F25%2F1124562975596.html3001.asp&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-228">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-228" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFRanka2007" class="citation web cs1">Ranka, Mohit (May 17, 2007). <a rel="nofollow" class="external text" href="http://www.osnews.com/story/17928/Google--Dont-Be-Evil">"Google&nbsp;– Don't Be Evil"</a>. OSNews. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100706224751/http://www.osnews.com/story/17928/Google--Dont-Be-Evil">Archived</a> from the original on July 6, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">November 27,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google+%E2%80%93+Don%27t+Be+Evil&amp;rft.pub=OSNews&amp;rft.date=2007-05-17&amp;rft.aulast=Ranka&amp;rft.aufirst=Mohit&amp;rft_id=http%3A%2F%2Fwww.osnews.com%2Fstory%2F17928%2FGoogle--Dont-Be-Evil&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-CCO-229">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-CCO_229-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMills2007" class="citation web cs1">Mills, Elinor (April 30, 2007). <a rel="nofollow" class="external text" href="https://web.archive.org/web/20101031155723/http://www.zdnet.com.au/meet-google-s-culture-czar-339275147.htm">"Google's culture czar"</a>. <i>ZDNet</i>. Archived from <a rel="nofollow" class="external text" href="http://www.zdnet.com.au/meet-google-s-culture-czar-339275147.htm">the original</a> on October 31, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">November 27,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=ZDNet&amp;rft.atitle=Google%27s+culture+czar&amp;rft.date=2007-04-30&amp;rft.aulast=Mills&amp;rft.aufirst=Elinor&amp;rft_id=http%3A%2F%2Fwww.zdnet.com.au%2Fmeet-google-s-culture-czar-339275147.htm&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-230">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-230" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKawamoto2005" class="citation news cs1">Kawamoto, Dawn (July 27, 2005). <a rel="nofollow" class="external text" href="http://news.cnet.com/Google-hit-with-job-discrimination-lawsuit/2100-1030_3-5807158.html?tag=nl">"Google hit with job discrimination lawsuit"</a>. <i><a href="/wiki/CNET" title="CNET">CNET</a></i>. <a href="/wiki/CBS_Interactive" class="mw-redirect" title="CBS Interactive">CBS Interactive</a><span class="reference-accessdate">. Retrieved <span class="nowrap">November 27,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=CNET&amp;rft.atitle=Google+hit+with+job+discrimination+lawsuit&amp;rft.date=2005-07-27&amp;rft.aulast=Kawamoto&amp;rft.aufirst=Dawn&amp;rft_id=http%3A%2F%2Fnews.cnet.com%2FGoogle-hit-with-job-discrimination-lawsuit%2F2100-1030_3-5807158.html%3Ftag%3Dnl&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-231">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-231" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/20071011205140/http://www.ctv.ca/servlet/ArticleNews/story/CTVNews/20071006/google_old_071006/20071006">"Google accused of ageism in reinstated lawsuit"</a>. <i>ctv.ca</i>. October 6, 2007. Archived from <a rel="nofollow" class="external text" href="http://www.ctv.ca/servlet/ArticleNews/story/CTVNews/20071006/google_old_071006/20071006">the original</a> on October 11, 2007<span class="reference-accessdate">. Retrieved <span class="nowrap">January 22,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=ctv.ca&amp;rft.atitle=Google+accused+of+ageism+in+reinstated+lawsuit&amp;rft.date=2007-10-06&amp;rft_id=http%3A%2F%2Fwww.ctv.ca%2Fservlet%2FArticleNews%2Fstory%2FCTVNews%2F20071006%2Fgoogle_old_071006%2F20071006&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-232">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-232" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFRosenblatt2014" class="citation web cs1">Rosenblatt, Seth (May 16, 2014). <a rel="nofollow" class="external text" href="https://www.cnet.com/news/judge-approves-first-payout-in-antitrust-wage-fixing-lawsuit/">"Judge approves first payout in antitrust wage-fixing lawsuit"</a>. <i><a href="/wiki/CNET" title="CNET">CNET</a></i>. <a href="/wiki/CBS_Interactive" class="mw-redirect" title="CBS Interactive">CBS Interactive</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170202030937/https://www.cnet.com/news/judge-approves-first-payout-in-antitrust-wage-fixing-lawsuit/">Archived</a> from the original on February 2, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">January 22,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=CNET&amp;rft.atitle=Judge+approves+first+payout+in+antitrust+wage-fixing+lawsuit&amp;rft.date=2014-05-16&amp;rft.aulast=Rosenblatt&amp;rft.aufirst=Seth&amp;rft_id=https%3A%2F%2Fwww.cnet.com%2Fnews%2Fjudge-approves-first-payout-in-antitrust-wage-fixing-lawsuit%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-:4-233">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-:4_233-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-:4_233-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.dhillonlaw.com/wp-content/uploads/2018/04/20180418-Damore-et-al.-v.-Google-FAC_Endorsed.pdf">"Damore, et al. v. Google - FAC"</a> <span class="cs1-format">(PDF)</span>. <i>www.dhillonlaw.com</i><span class="reference-accessdate">. Retrieved <span class="nowrap">December 12,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=www.dhillonlaw.com&amp;rft.atitle=Damore%2C+et+al.+v.+Google+-+FAC&amp;rft_id=https%3A%2F%2Fwww.dhillonlaw.com%2Fwp-content%2Fuploads%2F2018%2F04%2F20180418-Damore-et-al.-v.-Google-FAC_Endorsed.pdf&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-234">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-234" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.uniglobalunion.org/AlphaGlobal">"Google Unions Announce Global Alliance: "Together, we will change Alphabet<span class="cs1-kern-right">"</span>"</a>. <i>UNI Global Union</i><span class="reference-accessdate">. Retrieved <span class="nowrap">January 25,</span> 2021</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=UNI+Global+Union&amp;rft.atitle=Google+Unions+Announce+Global+Alliance%3A+%22Together%2C+we+will+change+Alphabet%22&amp;rft_id=https%3A%2F%2Fwww.uniglobalunion.org%2FAlphaGlobal&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-:5-235">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-:5_235-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-:5_235-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSchiffer2021" class="citation web cs1">Schiffer, Zoe (January 25, 2021). <a rel="nofollow" class="external text" href="https://www.theverge.com/2021/1/25/22243138/google-union-alphabet-workers-europe-announce-global-alliance">"Exclusive: Google workers across the globe announce international union alliance to hold Alphabet accountable"</a>. <i>The Verge</i><span class="reference-accessdate">. Retrieved <span class="nowrap">January 25,</span> 2021</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Exclusive%3A+Google+workers+across+the+globe+announce+international+union+alliance+to+hold+Alphabet+accountable&amp;rft.date=2021-01-25&amp;rft.aulast=Schiffer&amp;rft.aufirst=Zoe&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2021%2F1%2F25%2F22243138%2Fgoogle-union-alphabet-workers-europe-announce-global-alliance&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-236">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-236" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGhaffary2019" class="citation web cs1">Ghaffary, Shirin (September 9, 2019). <a rel="nofollow" class="external text" href="https://www.vox.com/recode/2019/9/9/20853647/google-employee-retaliation-harassment-me-too-exclusive">"Dozens of Google employees say they were retaliated against for reporting harassment"</a>. <i>Vox</i><span class="reference-accessdate">. Retrieved <span class="nowrap">January 25,</span> 2021</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Vox&amp;rft.atitle=Dozens+of+Google+employees+say+they+were+retaliated+against+for+reporting+harassment&amp;rft.date=2019-09-09&amp;rft.aulast=Ghaffary&amp;rft.aufirst=Shirin&amp;rft_id=https%3A%2F%2Fwww.vox.com%2Frecode%2F2019%2F9%2F9%2F20853647%2Fgoogle-employee-retaliation-harassment-me-too-exclusive&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-237">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-237" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFRahman2020" class="citation web cs1">Rahman, Rema (December 2, 2020). <a rel="nofollow" class="external text" href="https://thehill.com/policy/technology/528513-google-illegally-surveilled-and-fired-organizers-nlrb-complaint">"Google illegally surveilled and fired organizers, NLRB complaint alleges"</a>. <i>TheHill</i><span class="reference-accessdate">. Retrieved <span class="nowrap">January 25,</span> 2021</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TheHill&amp;rft.atitle=Google+illegally+surveilled+and+fired+organizers%2C+NLRB+complaint+alleges&amp;rft.date=2020-12-02&amp;rft.aulast=Rahman&amp;rft.aufirst=Rema&amp;rft_id=https%3A%2F%2Fthehill.com%2Fpolicy%2Ftechnology%2F528513-google-illegally-surveilled-and-fired-organizers-nlrb-complaint&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-238">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-238" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/intl/en/about/locations/?region=north-america">"Google: Our Offices"</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180726014216/https://www.google.com/intl/en/about/locations/?region=north-america">Archived</a> from the original on July 26, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">April 19,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google%3A+Our+Offices&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fintl%2Fen%2Fabout%2Flocations%2F%3Fregion%3Dnorth-america&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-239">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-239" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFReardon2006" class="citation web cs1">Reardon, Marguerite (October 11, 2006). <a rel="nofollow" class="external text" href="https://www.cnet.com/news/google-takes-a-bigger-bite-of-big-apple/">"Google takes a bigger bite of Big Apple"</a>. <i><a href="/wiki/CNET" title="CNET">CNET</a></i>. <a href="/wiki/CBS_Interactive" class="mw-redirect" title="CBS Interactive">CBS Interactive</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161012171317/https://www.cnet.com/news/google-takes-a-bigger-bite-of-big-apple/">Archived</a> from the original on October 12, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">June 13,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=CNET&amp;rft.atitle=Google+takes+a+bigger+bite+of+Big+Apple&amp;rft.date=2006-10-11&amp;rft.aulast=Reardon&amp;rft.aufirst=Marguerite&amp;rft_id=https%3A%2F%2Fwww.cnet.com%2Fnews%2Fgoogle-takes-a-bigger-bite-of-big-apple%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-240">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-240" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGrant2010" class="citation news cs1">Grant, Peter (December 3, 2010). <span class="cs1-lock-subscription" title="Paid subscription required"><a rel="nofollow" class="external text" href="https://www.wsj.com/articles/SB10001424052748704377004575651380545769418">"Google to Buy New York Office Building"</a></span>. <i><a href="/wiki/The_Wall_Street_Journal" title="The Wall Street Journal">The Wall Street Journal</a></i>. <a href="/wiki/Dow_Jones_%26_Company" title="Dow Jones &amp; Company">Dow Jones &amp; Company</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161010041640/http://www.wsj.com/articles/SB10001424052748704377004575651380545769418">Archived</a> from the original on October 10, 2016.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Wall+Street+Journal&amp;rft.atitle=Google+to+Buy+New+York+Office+Building&amp;rft.date=2010-12-03&amp;rft.aulast=Grant&amp;rft.aufirst=Peter&amp;rft_id=https%3A%2F%2Fwww.wsj.com%2Farticles%2FSB10001424052748704377004575651380545769418&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-241">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-241" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGustin2010" class="citation journal cs1">Gustin, Sam (December 22, 2010). <a rel="nofollow" class="external text" href="https://www.wired.com/2010/12/google-nyc/">"Google buys giant New York building for $1.9 billion"</a>. <i><a href="/wiki/Wired_(website)" class="mw-redirect" title="Wired (website)">Wired</a></i>. <a href="/wiki/Cond%C3%A9_Nast" title="Condé Nast">Condé Nast</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170102101149/https://www.wired.com/2010/12/google-nyc/">Archived</a> from the original on January 2, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 13,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Wired&amp;rft.atitle=Google+buys+giant+New+York+building+for+%241.9+billion&amp;rft.date=2010-12-22&amp;rft.aulast=Gustin&amp;rft.aufirst=Sam&amp;rft_id=https%3A%2F%2Fwww.wired.com%2F2010%2F12%2Fgoogle-nyc%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-242">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-242" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="https://phys.org/news/2018-03-google-nyc-chelsea-bn.html">"Google buys NYC's Chelsea Market building for $2.4 bn"</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180613184159/https://phys.org/news/2018-03-google-nyc-chelsea-bn.html">Archived</a> from the original on June 13, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">June 1,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Google+buys+NYC%27s+Chelsea+Market+building+for+%242.4+bn&amp;rft_id=https%3A%2F%2Fphys.org%2Fnews%2F2018-03-google-nyc-chelsea-bn.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-243">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-243" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://techcrunch.com/2018/03/20/google-bought-manhattans-chelsea-market-building-for-2-4-billion/">"Google bought Manhattan's Chelsea Market building for $2.4 billion – TechCrunch"</a>. <i>techcrunch.com</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180608214250/https://techcrunch.com/2018/03/20/google-bought-manhattans-chelsea-market-building-for-2-4-billion/">Archived</a> from the original on June 8, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">June 1,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=techcrunch.com&amp;rft.atitle=Google+bought+Manhattan%27s+Chelsea+Market+building+for+%242.4+billion+%E2%80%93+TechCrunch&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2018%2F03%2F20%2Fgoogle-bought-manhattans-chelsea-market-building-for-2-4-billion%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-244">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-244" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFEditorial" class="citation news cs1">Editorial, Reuters. <a rel="nofollow" class="external text" href="https://www.reuters.com/article/us-new-york-property-google-chelseamarke/google-closes-2-4-billion-chelsea-market-deal-to-expand-new-york-campus-idUSKBN1GW35U">"Google closes $2.4 billion Chelsea Market deal to expand New York..."</a> <i>U.S</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180527003159/https://www.reuters.com/article/us-new-york-property-google-chelseamarke/google-closes-2-4-billion-chelsea-market-deal-to-expand-new-york-campus-idUSKBN1GW35U">Archived</a> from the original on May 27, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">June 1,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=U.S.&amp;rft.atitle=Google+closes+%242.4+billion+Chelsea+Market+deal+to+expand+New+York...&amp;rft.aulast=Editorial&amp;rft.aufirst=Reuters&amp;rft_id=https%3A%2F%2Fwww.reuters.com%2Farticle%2Fus-new-york-property-google-chelseamarke%2Fgoogle-closes-2-4-billion-chelsea-market-deal-to-expand-new-york-campus-idUSKBN1GW35U&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-245">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-245" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="http://uk.pcmag.com/news/93278/report-alphabet-is-buying-chelsea-market-for-over-2b">"Report: Alphabet Is Buying Chelsea Market for Over $2B"</a>. <i>PCMag UK</i>. February 9, 2018. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180613210609/http://uk.pcmag.com/news/93278/report-alphabet-is-buying-chelsea-market-for-over-2b">Archived</a> from the original on June 13, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">June 1,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=PCMag+UK&amp;rft.atitle=Report%3A+Alphabet+Is+Buying+Chelsea+Market+for+Over+%242B&amp;rft.date=2018-02-09&amp;rft_id=http%3A%2F%2Fuk.pcmag.com%2Fnews%2F93278%2Freport-alphabet-is-buying-chelsea-market-for-over-2b&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-246">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-246" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGrant" class="citation news cs1">Grant, Douglas MacMillan, Eliot Brown and Peter. <a rel="nofollow" class="external text" href="https://www.wsj.com/articles/google-plans-large-new-york-city-expansion-1541636579">"Google Plans Large New York City Expansion"</a>. <i>WSJ</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181108182715/https://www.wsj.com/articles/google-plans-large-new-york-city-expansion-1541636579">Archived</a> from the original on November 8, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">November 8,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=WSJ&amp;rft.atitle=Google+Plans+Large+New+York+City+Expansion&amp;rft.aulast=Grant&amp;rft.aufirst=Douglas+MacMillan%2C+Eliot+Brown+and+Peter&amp;rft_id=https%3A%2F%2Fwww.wsj.com%2Farticles%2Fgoogle-plans-large-new-york-city-expansion-1541636579&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-247">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-247" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://newyork.cbslocal.com/2018/12/17/google-to-build-new-1-billion-campus-in-nyc/">"Google To Build New $1 Billion Campus In NYC"</a>. <i>CBS New York</i>. December 17, 2018. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181217165433/https://newyork.cbslocal.com/2018/12/17/google-to-build-new-1-billion-campus-in-nyc/">Archived</a> from the original on December 17, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">December 17,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=CBS+New+York&amp;rft.atitle=Google+To+Build+New+%241+Billion+Campus+In+NYC&amp;rft.date=2018-12-17&amp;rft_id=https%3A%2F%2Fnewyork.cbslocal.com%2F2018%2F12%2F17%2Fgoogle-to-build-new-1-billion-campus-in-nyc%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-248">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-248" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGartenberg2018" class="citation web cs1">Gartenberg, Chaim (December 17, 2018). <a rel="nofollow" class="external text" href="https://www.theverge.com/2018/12/17/18144448/google-nyc-campus-hudson-square-location-cost-open-date">"Google announces a new $1 billion NYC campus in Hudson Square"</a>. <i>The Verge</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181217203157/https://www.theverge.com/2018/12/17/18144448/google-nyc-campus-hudson-square-location-cost-open-date">Archived</a> from the original on December 17, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">December 17,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+announces+a+new+%241+billion+NYC+campus+in+Hudson+Square&amp;rft.date=2018-12-17&amp;rft.aulast=Gartenberg&amp;rft.aufirst=Chaim&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2018%2F12%2F17%2F18144448%2Fgoogle-nyc-campus-hudson-square-location-cost-open-date&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-249">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-249" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.npr.org/2018/12/17/677450467/google-will-spend-1-billion-for-new-york-city-campus-on-hudson-river">"Google Will Spend $1 Billion For New York City Campus On Hudson River"</a>. <i>NPR.org</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181217211911/https://www.npr.org/2018/12/17/677450467/google-will-spend-1-billion-for-new-york-city-campus-on-hudson-river">Archived</a> from the original on December 17, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">December 17,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=NPR.org&amp;rft.atitle=Google+Will+Spend+%241+Billion+For+New+York+City+Campus+On+Hudson+River&amp;rft_id=https%3A%2F%2Fwww.npr.org%2F2018%2F12%2F17%2F677450467%2Fgoogle-will-spend-1-billion-for-new-york-city-campus-on-hudson-river&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-250">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-250" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWeier2007" class="citation web cs1">Weier, Mary Hayes (October 24, 2007). <a rel="nofollow" class="external text" href="https://web.archive.org/web/20080503233009/http://www.informationweek.com/news/internet/webdev/showArticle.jhtml?articleID=202600809">"Inside Google's Michigan Office"</a>. <i><a href="/wiki/InformationWeek" title="InformationWeek">InformationWeek</a></i>. <a href="/wiki/UBM_plc" title="UBM plc">UBM plc</a>. Archived from <a rel="nofollow" class="external text" href="http://www.informationweek.com/news/internet/webdev/showArticle.jhtml?articleID=202600809">the original</a> on May 3, 2008<span class="reference-accessdate">. Retrieved <span class="nowrap">January 22,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=InformationWeek&amp;rft.atitle=Inside+Google%27s+Michigan+Office&amp;rft.date=2007-10-24&amp;rft.aulast=Weier&amp;rft.aufirst=Mary+Hayes&amp;rft_id=http%3A%2F%2Fwww.informationweek.com%2Fnews%2Finternet%2Fwebdev%2FshowArticle.jhtml%3FarticleID%3D202600809&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-251">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-251" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="https://www.webcitation.org/5hGpTE0LB?url=http://www.thepittsburghchannel.com/technology/10346550/detail.html">"Google Completes Pittsburgh Office, Holds Open House"</a>. <a href="/wiki/WTAE_TV" class="mw-redirect" title="WTAE TV">WTAE</a>. November 17, 2006. Archived from <a rel="nofollow" class="external text" href="http://www.thepittsburghchannel.com/technology/10346550/detail.html">the original</a> on June 4, 2009<span class="reference-accessdate">. Retrieved <span class="nowrap">January 13,</span> 2008</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Google+Completes+Pittsburgh+Office%2C+Holds+Open+House&amp;rft.date=2006-11-17&amp;rft_id=http%3A%2F%2Fwww.thepittsburghchannel.com%2Ftechnology%2F10346550%2Fdetail.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-252">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-252" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFOlson2010" class="citation web cs1">Olson, Thomas (December 8, 2010). <a rel="nofollow" class="external text" href="http://triblive.com/x/pittsburghtrib/business/s_712700.html">"Google search: Tech-minded workers"</a>. <a href="/wiki/Trib_Total_Media" class="mw-redirect" title="Trib Total Media">Trib Total Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20130603080308/http://triblive.com/x/pittsburghtrib/business/s_712700.html">Archived</a> from the original on June 3, 2013<span class="reference-accessdate">. Retrieved <span class="nowrap">December 8,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google+search%3A+Tech-minded+workers&amp;rft.pub=Trib+Total+Media&amp;rft.date=2010-12-08&amp;rft.aulast=Olson&amp;rft.aufirst=Thomas&amp;rft_id=http%3A%2F%2Ftriblive.com%2Fx%2Fpittsburghtrib%2Fbusiness%2Fs_712700.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-253">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-253" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/about/company/facts/locations/">"Google locations"</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20130815024220/https://www.google.com/about/company/facts/locations/">Archived</a> from the original on August 15, 2013<span class="reference-accessdate">. Retrieved <span class="nowrap">March 16,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google+locations&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fabout%2Fcompany%2Ffacts%2Flocations%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-254">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-254" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://careers.google.com/locations/sydney/">"Sydney"</a>. <i>Google Careers</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170505110757/https://careers.google.com/locations/sydney/">Archived</a> from the original on May 5, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 4,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Google+Careers&amp;rft.atitle=Sydney&amp;rft_id=https%3A%2F%2Fcareers.google.com%2Flocations%2Fsydney%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-255">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-255" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://careers.google.com/locations/london/">"London"</a>. <i>Google Careers</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170214074855/https://careers.google.com/locations/london/">Archived</a> from the original on February 14, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 4,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Google+Careers&amp;rft.atitle=London&amp;rft_id=https%3A%2F%2Fcareers.google.com%2Flocations%2Flondon%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-256">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-256" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMirani2013" class="citation web cs1">Mirani, Leo (November 1, 2013). <a rel="nofollow" class="external text" href="https://qz.com/139794/inside-googles-new-1-million-square-foot-london-office-three-years-before-its-ready/">"Inside Google's new 1-million-square-foot London office—three years before it's ready"</a>. <i><a href="/wiki/Quartz_(publication)" title="Quartz (publication)">Quartz</a></i>. <a href="/wiki/Atlantic_Media" title="Atlantic Media">Atlantic Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170316025208/https://qz.com/139794/inside-googles-new-1-million-square-foot-london-office-three-years-before-its-ready/">Archived</a> from the original on March 16, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 15,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Quartz&amp;rft.atitle=Inside+Google%27s+new+1-million-square-foot+London+office%E2%80%94three+years+before+it%27s+ready&amp;rft.date=2013-11-01&amp;rft.aulast=Mirani&amp;rft.aufirst=Leo&amp;rft_id=https%3A%2F%2Fqz.com%2F139794%2Finside-googles-new-1-million-square-foot-london-office-three-years-before-its-ready%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-257">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-257" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFVincent2017" class="citation web cs1">Vincent, James (June 1, 2017). <a rel="nofollow" class="external text" href="https://www.theverge.com/2017/6/1/15723642/google-london-office-pictures-headquarters-kings-cross">"Google's new London HQ is a 'landscraper' with a rooftop garden"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170603164958/https://www.theverge.com/2017/6/1/15723642/google-london-office-pictures-headquarters-kings-cross">Archived</a> from the original on June 3, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 4,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google%27s+new+London+HQ+is+a+%27landscraper%27+with+a+rooftop+garden&amp;rft.date=2017-06-01&amp;rft.aulast=Vincent&amp;rft.aufirst=James&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2017%2F6%2F1%2F15723642%2Fgoogle-london-office-pictures-headquarters-kings-cross&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-258">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-258" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBrian2017" class="citation web cs1">Brian, Matt (June 1, 2017). <a rel="nofollow" class="external text" href="https://www.engadget.com/2017/06/01/google-london-kings-cross-hq-plans-photos/">"Google's 'innovative' new London HQ features giant moving blinds"</a>. <i><a href="/wiki/Engadget" title="Engadget">Engadget</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170604003356/https://www.engadget.com/2017/06/01/google-london-kings-cross-hq-plans-photos/">Archived</a> from the original on June 4, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 4,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Engadget&amp;rft.atitle=Google%27s+%27innovative%27+new+London+HQ+features+giant+moving+blinds&amp;rft.date=2017-06-01&amp;rft.aulast=Brian&amp;rft.aufirst=Matt&amp;rft_id=https%3A%2F%2Fwww.engadget.com%2F2017%2F06%2F01%2Fgoogle-london-kings-cross-hq-plans-photos%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-259">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-259" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://indianexpress.com/article/india/google-to-build-biggest-campus-outside-us-in-hyderabad/">"Google to build biggest campus outside US in Hyderabad"</a>. <i><a href="/wiki/The_Indian_Express" title="The Indian Express">The Indian Express</a></i>. May 12, 2015. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20151118040601/http://indianexpress.com/article/india/google-to-build-biggest-campus-outside-us-in-hyderabad/">Archived</a> from the original on November 18, 2015<span class="reference-accessdate">. Retrieved <span class="nowrap">June 13,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Indian+Express&amp;rft.atitle=Google+to+build+biggest+campus+outside+US+in+Hyderabad&amp;rft.date=2015-05-12&amp;rft_id=http%3A%2F%2Findianexpress.com%2Farticle%2Findia%2Fgoogle-to-build-biggest-campus-outside-us-in-hyderabad%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-260">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-260" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://tech.firstpost.com/news-analysis/googles-upcoming-campus-in-hyderabad-to-be-its-biggest-outside-the-us-267059.html">"Google's upcoming campus in Hyderabad to be its biggest outside the US"</a>. <i><a href="/wiki/Firstpost" title="Firstpost">Firstpost</a></i>. <a href="/wiki/Network_18" class="mw-redirect" title="Network 18">Network 18</a>. May 13, 2015. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161118003932/http://tech.firstpost.com/news-analysis/googles-upcoming-campus-in-hyderabad-to-be-its-biggest-outside-the-us-267059.html">Archived</a> from the original on November 18, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">June 13,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Firstpost&amp;rft.atitle=Google%27s+upcoming+campus+in+Hyderabad+to+be+its+biggest+outside+the+US&amp;rft.date=2015-05-13&amp;rft_id=http%3A%2F%2Ftech.firstpost.com%2Fnews-analysis%2Fgoogles-upcoming-campus-in-hyderabad-to-be-its-biggest-outside-the-us-267059.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-261">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-261" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.google.com/about/datacenters/inside/locations/index.html">"Data center locations"</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180517162154/https://www.google.com/about/datacenters/inside/locations/index.html">Archived</a> from the original on May 17, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">May 17,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Data+center+locations&amp;rft_id=https%3A%2F%2Fwww.google.com%2Fabout%2Fdatacenters%2Finside%2Flocations%2Findex.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-262">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-262" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.datacenterknowledge.com/archives/2017/03/16/google-data-center-faq">"How Many Servers Does Google Have?"</a>. <i>Data Center Knowledge</i>. March 16, 2017. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190217073018/https://www.datacenterknowledge.com/archives/2017/03/16/google-data-center-faq">Archived</a> from the original on February 17, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">September 20,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Data+Center+Knowledge&amp;rft.atitle=How+Many+Servers+Does+Google+Have%3F&amp;rft.date=2017-03-16&amp;rft_id=https%3A%2F%2Fwww.datacenterknowledge.com%2Farchives%2F2017%2F03%2F16%2Fgoogle-data-center-faq&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-263">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-263" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://research.google.com/archive/googlecluster-ieee.pdf">"Google's Secret: 'Cheap and Fast' Hardware"</a> <span class="cs1-format">(PDF)</span>. <i>PCWorld</i>. October 10, 2003. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20091214182753/http://research.google.com/archive/googlecluster-ieee.pdf">Archived</a> <span class="cs1-format">(PDF)</span> from the original on December 14, 2009<span class="reference-accessdate">. Retrieved <span class="nowrap">May 26,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=PCWorld&amp;rft.atitle=Google%27s+Secret%3A+%27Cheap+and+Fast%27+Hardware&amp;rft.date=2003-10-10&amp;rft_id=https%3A%2F%2Fresearch.google.com%2Farchive%2Fgooglecluster-ieee.pdf&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-264">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-264" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFBarrosoDeanHolzle2003" class="citation journal cs1">Barroso, L.A.; Dean, J.; Holzle, U. (April 29, 2003). "Web search for a planet: the google cluster architecture". <i>IEEE Micro</i>. <b>23</b> (2): 22–28. <a href="/wiki/Doi_(identifier)" class="mw-redirect" title="Doi (identifier)">doi</a>:<a rel="nofollow" class="external text" href="https://doi.org/10.1109%2Fmm.2003.1196112">10.1109/mm.2003.1196112</a>. <a href="/wiki/ISSN_(identifier)" class="mw-redirect" title="ISSN (identifier)">ISSN</a>&nbsp;<a rel="nofollow" class="external text" href="//www.worldcat.org/issn/0272-1732">0272-1732</a>. <a href="/wiki/S2CID_(identifier)" class="mw-redirect" title="S2CID (identifier)">S2CID</a>&nbsp;<a rel="nofollow" class="external text" href="https://api.semanticscholar.org/CorpusID:15886858">15886858</a>. <q>We believe that the best price/performance tradeoff for our applications comes from fashioning a reliable computing infrastructure from clusters of unreliable commodity PCs.</q></cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=IEEE+Micro&amp;rft.atitle=Web+search+for+a+planet%3A+the+google+cluster+architecture&amp;rft.volume=23&amp;rft.issue=2&amp;rft.pages=22-28&amp;rft.date=2003-04-29&amp;rft_id=https%3A%2F%2Fapi.semanticscholar.org%2FCorpusID%3A15886858%23id-name%3DS2CID&amp;rft.issn=0272-1732&amp;rft_id=info%3Adoi%2F10.1109%2Fmm.2003.1196112&amp;rft.aulast=Barroso&amp;rft.aufirst=L.A.&amp;rft.au=Dean%2C+J.&amp;rft.au=Holzle%2C+U.&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-CNET2009-265">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-CNET2009_265-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-CNET2009_265-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="https://www.cnet.com/news/google-uncloaks-once-secret-server-10209580/">"Google uncloaks once-secret server"</a>. <i>CNET</i>. April 1, 2009. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180606105133/https://www.cnet.com/news/google-uncloaks-once-secret-server-10209580/">Archived</a> from the original on June 6, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">May 26,</span> 2018</span>. <q>Mainstream servers with x86 processors were the only option, he added. "Ten years ago...it was clear the only way to make (search) work as free product was to run on relatively cheap hardware. You can't run it on a <a href="/wiki/Mainframe_server" class="mw-redirect" title="Mainframe server">mainframe</a>. The margins just don't work out," he said.</q></cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=CNET&amp;rft.atitle=Google+uncloaks+once-secret+server&amp;rft.date=2009-04-01&amp;rft_id=https%3A%2F%2Fwww.cnet.com%2Fnews%2Fgoogle-uncloaks-once-secret-server-10209580%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-266">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-266" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.submarinenetworks.com/en/systems/brazil-us/curie">"Home - Submarine Networks"</a>. <i>Submarine Networks</i><span class="reference-accessdate">. Retrieved <span class="nowrap">July 14,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=Submarine+Networks&amp;rft.atitle=Home+-+Submarine+Networks&amp;rft_id=https%3A%2F%2Fwww.submarinenetworks.com%2Fen%2Fsystems%2Fbrazil-us%2Fcurie&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-267">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-267" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://venturebeat.com/2019/04/06/google-and-other-tech-giants-are-quietly-buying-up-the-most-important-part-of-the-internet/">"Google and other tech giants are quietly buying up the most important part of the internet"</a>. <i>VentureBeat</i>. April 6, 2019. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190425024849/https://venturebeat.com/2019/04/06/google-and-other-tech-giants-are-quietly-buying-up-the-most-important-part-of-the-internet/">Archived</a> from the original on April 25, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">April 25,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=VentureBeat&amp;rft.atitle=Google+and+other+tech+giants+are+quietly+buying+up+the+most+important+part+of+the+internet&amp;rft.date=2019-04-06&amp;rft_id=https%3A%2F%2Fventurebeat.com%2F2019%2F04%2F06%2Fgoogle-and-other-tech-giants-are-quietly-buying-up-the-most-important-part-of-the-internet%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-268">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-268" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSawers2019" class="citation web cs1">Sawers, Paul (April 24, 2019). <a rel="nofollow" class="external text" href="https://venturebeat.com/2019/04/24/how-google-is-building-its-huge-subsea-cable-infrastructure/">"How Google is building its huge subsea cable infrastructure"</a>. <i>VentureBeat</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190425163121/https://venturebeat.com/2019/04/24/how-google-is-building-its-huge-subsea-cable-infrastructure/">Archived</a> from the original on April 25, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">April 26,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=VentureBeat&amp;rft.atitle=How+Google+is+building+its+huge+subsea+cable+infrastructure&amp;rft.date=2019-04-24&amp;rft.aulast=Sawers&amp;rft.aufirst=Paul&amp;rft_id=https%3A%2F%2Fventurebeat.com%2F2019%2F04%2F24%2Fhow-google-is-building-its-huge-subsea-cable-infrastructure%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-269">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-269" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSawers2019" class="citation web cs1">Sawers, Paul (June 28, 2019). <a rel="nofollow" class="external text" href="https://venturebeat.com/2019/06/28/google-announces-equiano-a-privately-funded-subsea-cable-that-connects-europe-with-africa/">"Google announces Equiano, a privately funded subsea cable that connects Europe with Africa"</a>. <i>VentureBeat</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20201125060941/https://venturebeat.com/2019/06/28/google-announces-equiano-a-privately-funded-subsea-cable-that-connects-europe-with-africa/">Archived</a> from the original on November 25, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">December 31,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=VentureBeat&amp;rft.atitle=Google+announces+Equiano%2C+a+privately+funded+subsea+cable+that+connects+Europe+with+Africa&amp;rft.date=2019-06-28&amp;rft.aulast=Sawers&amp;rft.aufirst=Paul&amp;rft_id=https%3A%2F%2Fventurebeat.com%2F2019%2F06%2F28%2Fgoogle-announces-equiano-a-privately-funded-subsea-cable-that-connects-europe-with-africa%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-270">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-270" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLardinois2020" class="citation web cs1">Lardinois, Frederic (July 28, 2020). <a rel="nofollow" class="external text" href="https://social.techcrunch.com/2020/07/28/google-is-building-a-new-private-subsea-cable-between-europe-and-the-u-s/">"Google is building a new private subsea cable between Europe and the US"</a>. <i>TechCrunch</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20201231052511/https://techcrunch.com/2020/07/28/google-is-building-a-new-private-subsea-cable-between-europe-and-the-u-s/">Archived</a> from the original on December 31, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">December 31,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=Google+is+building+a+new+private+subsea+cable+between+Europe+and+the+US&amp;rft.date=2020-07-28&amp;rft.aulast=Lardinois&amp;rft.aufirst=Frederic&amp;rft_id=https%3A%2F%2Fsocial.techcrunch.com%2F2020%2F07%2F28%2Fgoogle-is-building-a-new-private-subsea-cable-between-europe-and-the-u-s%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-solar-271">
               <span class="mw-cite-backlink">^ <a href="#cite_ref-solar_271-0"><span class="cite-accessibility-label">Jump up to: </span><sup><i><b>a</b></i></sup></a> <a href="#cite_ref-solar_271-1"><sup><i><b>b</b></i></sup></a></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMarshall2006" class="citation news cs1">Marshall, Matt (October 16, 2006). <a rel="nofollow" class="external text" href="https://venturebeat.com/2006/10/16/google-builds-largest-solar-installation-in-us-oh-and-bigger-than-microsofts/">"Google builds largest solar installation in U.S. — oh, and bigger than Microsoft's"</a>. <i><a href="/wiki/VentureBeat" title="VentureBeat">VentureBeat</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=VentureBeat&amp;rft.atitle=Google+builds+largest+solar+installation+in+U.S.+%E2%80%94+oh%2C+and+bigger+than+Microsoft%E2%80%99s&amp;rft.date=2006-10-16&amp;rft.aulast=Marshall&amp;rft.aufirst=Matt&amp;rft_id=https%3A%2F%2Fventurebeat.com%2F2006%2F10%2F16%2Fgoogle-builds-largest-solar-installation-in-us-oh-and-bigger-than-microsofts%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-272">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-272" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFTHANGHAM2007" class="citation news cs1">THANGHAM, CHRIS V. (June 19, 2007). <a rel="nofollow" class="external text" href="http://www.digitaljournal.com/article/197545">"Google Solar Panels Produced 9,810 Kilowatt-hours of Electricity in 24 Hours"</a>. <i>Digitaljournal.com</i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Digitaljournal.com&amp;rft.atitle=Google+Solar+Panels+Produced+9%2C810+Kilowatt-hours+of+Electricity+in+24+Hours&amp;rft.date=2007-06-19&amp;rft.aulast=THANGHAM&amp;rft.aufirst=CHRIS+V.&amp;rft_id=http%3A%2F%2Fwww.digitaljournal.com%2Farticle%2F197545&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-273">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-273" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMcGrath2011" class="citation web cs1">McGrath, Jack (May 18, 2011). <a rel="nofollow" class="external text" href="http://www.technobuffalo.com/2011/05/18/googles-green-initiative-environmentally-conscious-technology/">"Google's Green Initiative: Environmentally Conscious Technology"</a>. TechnoBuffalo. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161012172247/http://www.technobuffalo.com/2011/05/18/googles-green-initiative-environmentally-conscious-technology/">Archived</a> from the original on October 12, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">January 22,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google%27s+Green+Initiative%3A+Environmentally+Conscious+Technology&amp;rft.pub=TechnoBuffalo&amp;rft.date=2011-05-18&amp;rft.aulast=McGrath&amp;rft.aufirst=Jack&amp;rft_id=http%3A%2F%2Fwww.technobuffalo.com%2F2011%2F05%2F18%2Fgoogles-green-initiative-environmentally-conscious-technology%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-274">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-274" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGlanz2011" class="citation web cs1">Glanz, James (September 8, 2011). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2011/09/09/technology/google-details-and-defends-its-use-of-electricity.html">"Google Details, and Defends, Its Use of Electricity"</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170312053616/http://www.nytimes.com/2011/09/09/technology/google-details-and-defends-its-use-of-electricity.html">Archived</a> from the original on March 12, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 9,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=Google+Details%2C+and+Defends%2C+Its+Use+of+Electricity&amp;rft.date=2011-09-08&amp;rft.aulast=Glanz&amp;rft.aufirst=James&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2011%2F09%2F09%2Ftechnology%2Fgoogle-details-and-defends-its-use-of-electricity.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-275">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-275" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMorrisonSweet2010" class="citation news cs1">Morrison, Scott; Sweet, Cassandra (May 4, 2010). <a rel="nofollow" class="external text" href="https://www.wsj.com/articles/SB10001424052748704342604575222420304732394">"Google Invests in Two Wind Farms"</a>. <i><a href="/wiki/The_Wall_Street_Journal" title="The Wall Street Journal">The Wall Street Journal</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20150213232857/http://www.wsj.com/articles/SB10001424052748704342604575222420304732394">Archived</a> from the original on February 13, 2015<span class="reference-accessdate">. Retrieved <span class="nowrap">November 27,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Wall+Street+Journal&amp;rft.atitle=Google+Invests+in+Two+Wind+Farms&amp;rft.date=2010-05-04&amp;rft.aulast=Morrison&amp;rft.aufirst=Scott&amp;rft.au=Sweet%2C+Cassandra&amp;rft_id=https%3A%2F%2Fwww.wsj.com%2Farticles%2FSB10001424052748704342604575222420304732394&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-276">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-276" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="http://news.cnet.com/8301-11128_3-10456435-54.html">"Google Energy can now buy and sell energy"</a>. <i>Cnet.com</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20130919091407/http://news.cnet.com/8301-11128_3-10456435-54.html">Archived</a> from the original on September 19, 2013<span class="reference-accessdate">. Retrieved <span class="nowrap">September 23,</span> 2013</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Cnet.com&amp;rft.atitle=Google+Energy+can+now+buy+and+sell+energy&amp;rft_id=http%3A%2F%2Fnews.cnet.com%2F8301-11128_3-10456435-54.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-277">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-277" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFTodd_Woody2013" class="citation news cs1">Todd Woody (September 18, 2013). <a rel="nofollow" class="external text" href="http://qz.com/125407/google-is-on-the-way-to-quietly-becoming-an-electric-utility/">"Google is on the way to quietly becoming an electric utility"</a>. <i>Quartz</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20130921050811/http://qz.com/125407/google-is-on-the-way-to-quietly-becoming-an-electric-utility/">Archived</a> from the original on September 21, 2013<span class="reference-accessdate">. Retrieved <span class="nowrap">September 23,</span> 2013</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Quartz&amp;rft.atitle=Google+is+on+the+way+to+quietly+becoming+an+electric+utility&amp;rft.date=2013-09-18&amp;rft.au=Todd+Woody&amp;rft_id=http%3A%2F%2Fqz.com%2F125407%2Fgoogle-is-on-the-way-to-quietly-becoming-an-electric-utility%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-wind_energy-278">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-wind_energy_278-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.webcitation.org/659XgHPv9?url=http://news.techworld.com/green-it/3232690/google-buys-power-from-iowa-wind-farm/?olo=rss">"Google buys power from Iowa wind farm"</a>. <i>News.techworld.com</i>. July 21, 2010. Archived from <a rel="nofollow" class="external text" href="http://news.techworld.com/green-it/3232690/google-buys-power-from-iowa-wind-farm/?olo=rss">the original</a> on February 2, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">October 26,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=News.techworld.com&amp;rft.atitle=Google+buys+power+from+Iowa+wind+farm&amp;rft.date=2010-07-21&amp;rft_id=http%3A%2F%2Fnews.techworld.com%2Fgreen-it%2F3232690%2Fgoogle-buys-power-from-iowa-wind-farm%2F%3Folo%3Drss&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-279">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-279" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHölzle2016" class="citation web cs1">Hölzle, Urs (December 6, 2016). <a rel="nofollow" class="external text" href="https://blog.google/topics/environment/100-percent-renewable-energy/">"We're set to reach 100% renewable energy — and it's just the beginning"</a>. <i>The Keyword Google Blog</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161208102229/https://www.blog.google/topics/environment/100-percent-renewable-energy/">Archived</a> from the original on December 8, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">December 28,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Keyword+Google+Blog&amp;rft.atitle=We%27re+set+to+reach+100%25+renewable+energy+%E2%80%94+and+it%27s+just+the+beginning&amp;rft.date=2016-12-06&amp;rft.aulast=H%C3%B6lzle&amp;rft.aufirst=Urs&amp;rft_id=https%3A%2F%2Fblog.google%2Ftopics%2Fenvironment%2F100-percent-renewable-energy%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-280">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-280" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFStatt2016" class="citation web cs1">Statt, Nick (December 6, 2016). <a rel="nofollow" class="external text" href="https://www.theverge.com/2016/12/6/13852004/google-data-center-oklahoma-renewable-energy-climate-change">"Google just notched a big victory in the fight against climate change"</a>. <i><a href="/wiki/The_Verge" title="The Verge">The Verge</a></i>. <a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161208001307/http://www.theverge.com/2016/12/6/13852004/google-data-center-oklahoma-renewable-energy-climate-change">Archived</a> from the original on December 8, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">December 28,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Verge&amp;rft.atitle=Google+just+notched+a+big+victory+in+the+fight+against+climate+change&amp;rft.date=2016-12-06&amp;rft.aulast=Statt&amp;rft.aufirst=Nick&amp;rft_id=https%3A%2F%2Fwww.theverge.com%2F2016%2F12%2F6%2F13852004%2Fgoogle-data-center-oklahoma-renewable-energy-climate-change&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-281">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-281" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFEtherington2016" class="citation web cs1">Etherington, Darrell (December 7, 2016). <a rel="nofollow" class="external text" href="https://techcrunch.com/2016/12/06/google-says-it-will-hit-100-renewable-energy-by-2017/">"Google says it will hit 100% renewable energy by 2017"</a>. <i><a href="/wiki/TechCrunch" title="TechCrunch">TechCrunch</a></i>. <a href="/wiki/AOL" title="AOL">AOL</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20161207164915/https://techcrunch.com/2016/12/06/google-says-it-will-hit-100-renewable-energy-by-2017/">Archived</a> from the original on December 7, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">December 28,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=TechCrunch&amp;rft.atitle=Google+says+it+will+hit+100%25+renewable+energy+by+2017&amp;rft.date=2016-12-07&amp;rft.aulast=Etherington&amp;rft.aufirst=Darrell&amp;rft_id=https%3A%2F%2Ftechcrunch.com%2F2016%2F12%2F06%2Fgoogle-says-it-will-hit-100-renewable-energy-by-2017%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-282">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-282" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFDonnelly2017" class="citation news cs1">Donnelly, Grace (November 30, 2017). <span class="cs1-lock-subscription" title="Paid subscription required"><a rel="nofollow" class="external text" href="http://fortune.com/2017/12/01/google-clean-energy/">"Google Just Bought Enough Wind Power to Run 100% On Renewable Energy"</a></span>. <i>Fortune</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20171201172833/http://fortune.com/2017/12/01/google-clean-energy/">Archived</a> from the original on December 1, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">December 1,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Fortune&amp;rft.atitle=Google+Just+Bought+Enough+Wind+Power+to+Run+100%25+On+Renewable+Energy&amp;rft.date=2017-11-30&amp;rft.aulast=Donnelly&amp;rft.aufirst=Grace&amp;rft_id=http%3A%2F%2Ffortune.com%2F2017%2F12%2F01%2Fgoogle-clean-energy%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-283">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-283" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFcorrespondent2019" class="citation news cs1">correspondent, Jillian Ambrose Energy (September 20, 2019). <a rel="nofollow" class="external text" href="https://www.theguardian.com/technology/2019/sep/20/google-says-its-energy-deals-will-lead-to-2bn-wind-and-solar-investment">"Google signs up to $2bn wind and solar investment"</a>. <i>The Guardian</i>. <a href="/wiki/ISSN_(identifier)" class="mw-redirect" title="ISSN (identifier)">ISSN</a>&nbsp;<a rel="nofollow" class="external text" href="//www.worldcat.org/issn/0261-3077">0261-3077</a><span class="reference-accessdate">. Retrieved <span class="nowrap">September 25,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Guardian&amp;rft.atitle=Google+signs+up+to+%242bn+wind+and+solar+investment&amp;rft.date=2019-09-20&amp;rft.issn=0261-3077&amp;rft.aulast=correspondent&amp;rft.aufirst=Jillian+Ambrose+Energy&amp;rft_id=https%3A%2F%2Fwww.theguardian.com%2Ftechnology%2F2019%2Fsep%2F20%2Fgoogle-says-its-energy-deals-will-lead-to-2bn-wind-and-solar-investment&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-284">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-284" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHern2020" class="citation web cs1">Hern, Alex (September 15, 2020). <a rel="nofollow" class="external text" href="https://www.theguardian.com/environment/2020/sep/15/facebook-and-google-announce-plans-become-carbon-neutral">"Facebook and Google announce plans to become carbon neutral"</a>. <i>the Guardian</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20201209182453/https://www.theguardian.com/environment/2020/sep/15/facebook-and-google-announce-plans-become-carbon-neutral">Archived</a> from the original on December 3, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">December 28,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=the+Guardian&amp;rft.atitle=Facebook+and+Google+announce+plans+to+become+carbon+neutral&amp;rft.date=2020-09-15&amp;rft.aulast=Hern&amp;rft.aufirst=Alex&amp;rft_id=http%3A%2F%2Fwww.theguardian.com%2Fenvironment%2F2020%2Fsep%2F15%2Ffacebook-and-google-announce-plans-become-carbon-neutral&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-285">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-285" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.cnbc.com/2020/09/14/google-aims-to-run-on-carbon-free-energy-by-2030.html">"Google aims to run on carbon-free energy by 2030"</a>. <i>CNBC</i>. September 14, 2020. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20201210191711/https://www.cnbc.com/2020/09/14/google-aims-to-run-on-carbon-free-energy-by-2030.html">Archived</a> from the original on December 10, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">December 28,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=CNBC&amp;rft.atitle=Google+aims+to+run+on+carbon-free+energy+by+2030&amp;rft.date=2020-09-14&amp;rft_id=https%3A%2F%2Fwww.cnbc.com%2F2020%2F09%2F14%2Fgoogle-aims-to-run-on-carbon-free-energy-by-2030.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-286">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-286" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFSchoon2020" class="citation web cs1">Schoon, Ben (October 26, 2020). <a rel="nofollow" class="external text" href="https://9to5google.com/2020/10/26/google-plastic-packaging-sustainability/">"Google will ditch plastic packaging by 2025"</a>. <i>9to5Google</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20201104130117/https://9to5google.com/2020/10/26/google-plastic-packaging-sustainability/">Archived</a> from the original on November 4, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">December 28,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=9to5Google&amp;rft.atitle=Google+will+ditch+plastic+packaging+by+2025&amp;rft.date=2020-10-26&amp;rft.aulast=Schoon&amp;rft.aufirst=Ben&amp;rft_id=https%3A%2F%2F9to5google.com%2F2020%2F10%2F26%2Fgoogle-plastic-packaging-sustainability%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-287">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-287" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFLegum" class="citation web cs1">Legum, Judd. <a rel="nofollow" class="external text" href="https://popular.info/p/these-corporations-are-quietly-bankrolling">"These corporations are quietly bankrolling Congress' top climate denier"</a>. <i>popular.info</i><span class="reference-accessdate">. Retrieved <span class="nowrap">February 7,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=popular.info&amp;rft.atitle=These+corporations+are+quietly+bankrolling+Congress%27+top+climate+denier&amp;rft.aulast=Legum&amp;rft.aufirst=Judd&amp;rft_id=https%3A%2F%2Fpopular.info%2Fp%2Fthese-corporations-are-quietly-bankrolling&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-288">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-288" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKirchgaessner2019" class="citation news cs1">Kirchgaessner, Stephanie (October 11, 2019). <a rel="nofollow" class="external text" href="https://www.theguardian.com/environment/2019/oct/11/google-contributions-climate-change-deniers">"Revealed: Google made large contributions to climate change deniers"</a>. <i>The Guardian</i>. <a href="/wiki/ISSN_(identifier)" class="mw-redirect" title="ISSN (identifier)">ISSN</a>&nbsp;<a rel="nofollow" class="external text" href="//www.worldcat.org/issn/0261-3077">0261-3077</a><span class="reference-accessdate">. Retrieved <span class="nowrap">February 7,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Guardian&amp;rft.atitle=Revealed%3A+Google+made+large+contributions+to+climate+change+deniers&amp;rft.date=2019-10-11&amp;rft.issn=0261-3077&amp;rft.aulast=Kirchgaessner&amp;rft.aufirst=Stephanie&amp;rft_id=https%3A%2F%2Fwww.theguardian.com%2Fenvironment%2F2019%2Foct%2F11%2Fgoogle-contributions-climate-change-deniers&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-289">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-289" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKirchgaessner2019" class="citation news cs1">Kirchgaessner, Stephanie (October 11, 2019). <a rel="nofollow" class="external text" href="https://www.theguardian.com/environment/2019/oct/11/obscure-law-google-climate-deniers-section-230">"The obscure law that explains why Google backs climate deniers"</a>. <i>The Guardian</i>. <a href="/wiki/ISSN_(identifier)" class="mw-redirect" title="ISSN (identifier)">ISSN</a>&nbsp;<a rel="nofollow" class="external text" href="//www.worldcat.org/issn/0261-3077">0261-3077</a><span class="reference-accessdate">. Retrieved <span class="nowrap">February 7,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Guardian&amp;rft.atitle=The+obscure+law+that+explains+why+Google+backs+climate+deniers&amp;rft.date=2019-10-11&amp;rft.issn=0261-3077&amp;rft.aulast=Kirchgaessner&amp;rft.aufirst=Stephanie&amp;rft_id=https%3A%2F%2Fwww.theguardian.com%2Fenvironment%2F2019%2Foct%2F11%2Fobscure-law-google-climate-deniers-section-230&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-philanthropy-290">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-philanthropy_290-0" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/20100714080922/http://www.google.org/about.html">"About the Foundation"</a>. Google, Inc. Archived from <a rel="nofollow" class="external text" href="http://www.google.org/about.html">the original</a> on July 14, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">July 16,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=About+the+Foundation&amp;rft.pub=Google%2C+Inc.&amp;rft_id=http%3A%2F%2Fwww.google.org%2Fabout.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-291">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-291" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHafner2006" class="citation web cs1">Hafner, Katie (September 14, 2006). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2006/09/14/technology/14google.html">"Philanthropy Google's Way: Not the Usual"</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20160723065526/http://www.nytimes.com/2006/09/14/technology/14google.html">Archived</a> from the original on July 23, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">March 9,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=Philanthropy+Google%27s+Way%3A+Not+the+Usual&amp;rft.date=2006-09-14&amp;rft.aulast=Hafner&amp;rft.aufirst=Katie&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2006%2F09%2F14%2Ftechnology%2F14google.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-292">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-292" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFHelft2009" class="citation web cs1">Helft, Miguel (February 23, 2009). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2009/02/24/technology/companies/24google.html">"Google Chief for Charity Steps Down on Revamp"</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170422112540/http://www.nytimes.com/2009/02/24/technology/companies/24google.html">Archived</a> from the original on April 22, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 9,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=Google+Chief+for+Charity+Steps+Down+on+Revamp&amp;rft.date=2009-02-23&amp;rft.aulast=Helft&amp;rft.aufirst=Miguel&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2009%2F02%2F24%2Ftechnology%2Fcompanies%2F24google.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-293">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-293" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.webcitation.org/5hT8OddCZ?url=http://www.project10tothe100.com/">"Project 10 to the 100th"</a>. Google, Inc. Archived from <a rel="nofollow" class="external text" href="http://www.project10tothe100.com/">the original</a> on June 12, 2009<span class="reference-accessdate">. Retrieved <span class="nowrap">July 16,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Project+10+to+the+100th&amp;rft.pub=Google%2C+Inc.&amp;rft_id=http%3A%2F%2Fwww.project10tothe100.com%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-294">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-294" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFVan_Burskirk2010" class="citation news cs1">Van Burskirk, Elliot (June 28, 2010). <a rel="nofollow" class="external text" href="https://www.wired.com/epicenter/2010/06/google-struggles-to-give-away-10-million/">"Google Struggles to Give Away $10&nbsp;million"</a>. <i><a href="/wiki/Wired_(website)" class="mw-redirect" title="Wired (website)">Wired</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100831172215/http://www.wired.com/epicenter/2010/06/google-struggles-to-give-away-10-million/">Archived</a> from the original on August 31, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">September 26,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Wired&amp;rft.atitle=Google+Struggles+to+Give+Away+%2410+million&amp;rft.date=2010-06-28&amp;rft.aulast=Van+Burskirk&amp;rft.aufirst=Elliot&amp;rft_id=https%3A%2F%2Fwww.wired.com%2Fepicenter%2F2010%2F06%2Fgoogle-struggles-to-give-away-10-million%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-295">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-295" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFTwohill2010" class="citation web cs1">Twohill, Lorraine (September 24, 2010). <a rel="nofollow" class="external text" href="http://googleblog.blogspot.com/2010/09/10-million-for-project-10100-winners.html">"$10&nbsp;million for Project 10^100 winners"</a>. Google, Inc. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20100926020623/http://googleblog.blogspot.com/2010/09/10-million-for-project-10100-winners.html">Archived</a> from the original on September 26, 2010<span class="reference-accessdate">. Retrieved <span class="nowrap">September 26,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=%2410+million+for+Project+10%5E100+winners&amp;rft.pub=Google%2C+Inc.&amp;rft.date=2010-09-24&amp;rft.aulast=Twohill&amp;rft.aufirst=Lorraine&amp;rft_id=http%3A%2F%2Fgoogleblog.blogspot.com%2F2010%2F09%2F10-million-for-project-10100-winners.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-296"><span class="mw-cite-backlink"><b><a href="#cite_ref-296" aria-label="Jump up" title="Jump up">^</a></b></span> <span class="reference-text"><a rel="nofollow" class="external text" href="https://www.youtube.com/watch?v=qDL7yoz1TGQ">The 2007</a> <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181120090220/https://www.youtube.com/watch?v=qDL7yoz1TGQ">Archived</a> November 20, 2018, at the <a href="/wiki/Wayback_Machine" title="Wayback Machine">Wayback Machine</a> <a href="/wiki/Julia_Robinson_Mathematics_Festival" title="Julia Robinson Mathematics Festival">Julia Robinson Mathematics Festival</a> at Google was the founding of this event for middle school and high school students. video</span></li>
            <li id="cite_note-297">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-297" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFDuffy2011" class="citation web cs1">Duffy, Jill (January 21, 2011). <a rel="nofollow" class="external text" href="https://www.pcmag.com/article2/0,2817,2376099,00.asp">"Mathletes Receive €1M Donation from Google"</a>. <i><a href="/wiki/PC_Magazine" class="mw-redirect" title="PC Magazine">PC Magazine</a></i>. <a href="/wiki/Ziff_Davis" title="Ziff Davis">Ziff Davis</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170323234649/http://www.pcmag.com/article2/0,2817,2376099,00.asp">Archived</a> from the original on March 23, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 23,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=PC+Magazine&amp;rft.atitle=Mathletes+Receive+%E2%82%AC1M+Donation+from+Google&amp;rft.date=2011-01-21&amp;rft.aulast=Duffy&amp;rft.aufirst=Jill&amp;rft_id=https%3A%2F%2Fwww.pcmag.com%2Farticle2%2F0%2C2817%2C2376099%2C00.asp&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-298">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-298" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/20110724154518/https://www.imo2011.nl/node/39">"Google donating 1&nbsp;million euros to IMO"</a>. January 20, 2011. Archived from <a rel="nofollow" class="external text" href="https://www.imo2011.nl/node/39">the original</a> on July 24, 2011<span class="reference-accessdate">. Retrieved <span class="nowrap">February 4,</span> 2011</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google+donating+1+million+euros+to+IMO&amp;rft.date=2011-01-20&amp;rft_id=https%3A%2F%2Fwww.imo2011.nl%2Fnode%2F39&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-299">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-299" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://www.pinknews.co.uk/2012/07/08/google-launches-legalise-love-gay-rights-campaign/">"Google launches 'Legalise Love' gay rights campaign"</a>. <i>PinkNews.co.uk</i>. July 8, 2012. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20140819044558/http://www.pinknews.co.uk/2012/07/08/google-launches-legalise-love-gay-rights-campaign/">Archived</a> from the original on August 19, 2014<span class="reference-accessdate">. Retrieved <span class="nowrap">September 9,</span> 2014</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=PinkNews.co.uk&amp;rft.atitle=Google+launches+%27Legalise+Love%27+gay+rights+campaign&amp;rft.date=2012-07-08&amp;rft_id=http%3A%2F%2Fwww.pinknews.co.uk%2F2012%2F07%2F08%2Fgoogle-launches-legalise-love-gay-rights-campaign%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-300">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-300" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFDrucker2010" class="citation news cs1">Drucker, Jesse (October 21, 2010). <span class="cs1-lock-subscription" title="Paid subscription required"><a rel="nofollow" class="external text" href="https://www.bloomberg.com/news/articles/2010-10-21/google-2-4-rate-shows-how-60-billion-u-s-revenue-lost-to-tax-loopholes">"Google 2.4% Rate Shows How $60 Billion Is Lost to Tax Loopholes"</a></span>. <i><a href="/wiki/Bloomberg_News" title="Bloomberg News">Bloomberg News</a></i>. <a href="/wiki/Bloomberg_L.P." title="Bloomberg L.P.">Bloomberg L.P.</a> <a rel="nofollow" class="external text" href="https://web.archive.org/web/20160922035532/http://www.bloomberg.com/news/articles/2010-10-21/google-2-4-rate-shows-how-60-billion-u-s-revenue-lost-to-tax-loopholes">Archived</a> from the original on September 22, 2016.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Bloomberg+News&amp;rft.atitle=Google+2.4%25+Rate+Shows+How+%2460+Billion+Is+Lost+to+Tax+Loopholes&amp;rft.date=2010-10-21&amp;rft.aulast=Drucker&amp;rft.aufirst=Jesse&amp;rft_id=https%3A%2F%2Fwww.bloomberg.com%2Fnews%2Farticles%2F2010-10-21%2Fgoogle-2-4-rate-shows-how-60-billion-u-s-revenue-lost-to-tax-loopholes&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-301">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-301" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.nytimes.com/2018/02/20/magazine/the-case-against-google.html">"The Case Against Google"</a>. <i>nytimes.com</i>. February 20, 2018. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180319192049/https://www.nytimes.com/2018/02/20/magazine/the-case-against-google.html">Archived</a> from the original on March 19, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">March 21,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=nytimes.com&amp;rft.atitle=The+Case+Against+Google&amp;rft.date=2018-02-20&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2018%2F02%2F20%2Fmagazine%2Fthe-case-against-google.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-302">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-302" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="http://news.bbc.co.uk/2/hi/technology/6740075.stm">"Google ranked 'worst' on privacy"</a>. <i>BBC News</i>. June 11, 2007. <a rel="nofollow" class="external text" href="https://www.webcitation.org/6BYbPRqrU?url=http://news.bbc.co.uk/2/hi/technology/6740075.stm">Archived</a> from the original on October 20, 2012<span class="reference-accessdate">. Retrieved <span class="nowrap">April 30,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=BBC+News&amp;rft.atitle=Google+ranked+%27worst%27+on+privacy&amp;rft.date=2007-06-11&amp;rft_id=http%3A%2F%2Fnews.bbc.co.uk%2F2%2Fhi%2Ftechnology%2F6740075.stm&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-303">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-303" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFRosen2008" class="citation web cs1">Rosen, Jeffrey (November 28, 2008). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2008/11/30/magazine/30google-t.html">"Google's Gatekeepers"</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170228140546/http://www.nytimes.com/2008/11/30/magazine/30google-t.html">Archived</a> from the original on February 28, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 9,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=Google%27s+Gatekeepers&amp;rft.date=2008-11-28&amp;rft.aulast=Rosen&amp;rft.aufirst=Jeffrey&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2008%2F11%2F30%2Fmagazine%2F30google-t.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-304">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-304" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="http://news.bbc.co.uk/1/hi/technology/4645596.stm">"Google censors itself for China"</a>. <i>BBC News</i>. January 25, 2006. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181119073206/http://news.bbc.co.uk/1/hi/technology/4645596.stm">Archived</a> from the original on November 19, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">August 4,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=BBC+News&amp;rft.atitle=Google+censors+itself+for+China&amp;rft.date=2006-01-25&amp;rft_id=http%3A%2F%2Fnews.bbc.co.uk%2F1%2Fhi%2Ftechnology%2F4645596.stm&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-305">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-305" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="https://theintercept.com/2018/08/01/google-china-search-engine-censorship/">"Google Plans to Launch Censored Search Engine in China, Leaked Documents Reveal · Ryan Gallagher"</a>. <i>The Intercept</i>. August 1, 2018. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180801120009/https://theintercept.com/2018/08/01/google-china-search-engine-censorship/">Archived</a> from the original on August 1, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">August 4,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=The+Intercept&amp;rft.atitle=Google+Plans+to+Launch+Censored+Search+Engine+in+China%2C+Leaked+Documents+Reveal+%C2%B7+Ryan+Gallagher&amp;rft.date=2018-08-01&amp;rft_id=https%3A%2F%2Ftheintercept.com%2F2018%2F08%2F01%2Fgoogle-china-search-engine-censorship%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-306">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-306" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFDisis2018" class="citation news cs1">Disis, Jill (September 26, 2018). <a rel="nofollow" class="external text" href="https://money.cnn.com/2018/09/26/technology/google-dragonfly-senate-hearing/index.html">"Google grilled over 'Project Dragonfly' at Senate hearing on data privacy"</a>. <i>CNN</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180926222719/https://money.cnn.com/2018/09/26/technology/google-dragonfly-senate-hearing/index.html">Archived</a> from the original on September 26, 2018.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=CNN&amp;rft.atitle=Google+grilled+over+%27Project+Dragonfly%27+at+Senate+hearing+on+data+privacy&amp;rft.date=2018-09-26&amp;rft.aulast=Disis&amp;rft.aufirst=Jill&amp;rft_id=https%3A%2F%2Fmoney.cnn.com%2F2018%2F09%2F26%2Ftechnology%2Fgoogle-dragonfly-senate-hearing%2Findex.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-307">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-307" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGallagher2018" class="citation web cs1">Gallagher, Ryan (December 17, 2018). <a rel="nofollow" class="external text" href="https://theintercept.com/2018/12/17/google-china-censored-search-engine-2/">"Google's Secret China Project "Effectively Ended" After Internal Confrontation"</a>. <i>The Intercept</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190321020856/https://theintercept.com/2018/12/17/google-china-censored-search-engine-2/">Archived</a> from the original on March 21, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">December 17,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Intercept&amp;rft.atitle=Google%27s+Secret+China+Project+%22Effectively+Ended%22+After+Internal+Confrontation&amp;rft.date=2018-12-17&amp;rft.aulast=Gallagher&amp;rft.aufirst=Ryan&amp;rft_id=https%3A%2F%2Ftheintercept.com%2F2018%2F12%2F17%2Fgoogle-china-censored-search-engine-2%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-308">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-308" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.bbc.com/news/world-us-canada-23123964">"Edward Snowden: Leaks that exposed US spy programme"</a>. <i><a href="/wiki/BBC_News" title="BBC News">BBC News</a></i>. January 17, 2014. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170320171345/http://www.bbc.com/news/world-us-canada-23123964">Archived</a> from the original on March 20, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">March 25,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=BBC+News&amp;rft.atitle=Edward+Snowden%3A+Leaks+that+exposed+US+spy+programme&amp;rft.date=2014-01-17&amp;rft_id=https%3A%2F%2Fwww.bbc.com%2Fnews%2Fworld-us-canada-23123964&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-309">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-309" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGreenwaldMacAskill2013" class="citation web cs1">Greenwald, Glenn; MacAskill, Ewen (June 7, 2013). <a rel="nofollow" class="external text" href="https://www.theguardian.com/world/2013/jun/06/us-tech-giants-nsa-data">"NSA Prism program taps in to user data of Apple, Google and others"</a>. <i><a href="/wiki/The_Guardian" title="The Guardian">The Guardian</a></i>. <a href="/wiki/Guardian_Media_Group" title="Guardian Media Group">Guardian Media Group</a>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20060818114650/http://www.guardian.co.uk/world/2013/jun/06/us-tech-giants-nsa-data">Archived</a> from the original on August 18, 2006<span class="reference-accessdate">. Retrieved <span class="nowrap">March 25,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+Guardian&amp;rft.atitle=NSA+Prism+program+taps+in+to+user+data+of+Apple%2C+Google+and+others&amp;rft.date=2013-06-07&amp;rft.aulast=Greenwald&amp;rft.aufirst=Glenn&amp;rft.au=MacAskill%2C+Ewen&amp;rft_id=https%3A%2F%2Fwww.theguardian.com%2Fworld%2F2013%2Fjun%2F06%2Fus-tech-giants-nsa-data&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-310"><span class="mw-cite-backlink"><b><a href="#cite_ref-310" aria-label="Jump up" title="Jump up">^</a></b></span> <span class="reference-text">"<a rel="nofollow" class="external text" href="https://arstechnica.com/gadgets/2018/04/google-should-not-be-in-the-business-of-war-googlers-decry-pentagon-project/">Google employees revolt, say company should shut down military drone project</a> <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180408141509/https://arstechnica.com/gadgets/2018/04/google-should-not-be-in-the-business-of-war-googlers-decry-pentagon-project/">Archived</a> April 8, 2018, at the <a href="/wiki/Wayback_Machine" title="Wayback Machine">Wayback Machine</a>". <i><a href="/wiki/Ars_Technica" title="Ars Technica">Ars Technica</a></i>. April 4, 2018.</span></li>
            <li id="cite_note-311"><span class="mw-cite-backlink"><b><a href="#cite_ref-311" aria-label="Jump up" title="Jump up">^</a></b></span> <span class="reference-text">"<a rel="nofollow" class="external text" href="https://www.independent.co.uk/news/business/news/google-protest-pentagon-drones-programme-company-sundar-pichai-department-of-defense-a8290111.html">Google staff protest company's involvement with Pentagon drones programme</a> <a rel="nofollow" class="external text" href="https://web.archive.org/web/20180409174803/https://www.independent.co.uk/news/business/news/google-protest-pentagon-drones-programme-company-sundar-pichai-department-of-defense-a8290111.html">Archived</a> April 9, 2018, at the <a href="/wiki/Wayback_Machine" title="Wayback Machine">Wayback Machine</a>". <i>The Independent</i>. April 4, 2018.</span></li>
            <li id="cite_note-312">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-312" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFWakabayashi,_DaisukeShane,_Scott2018" class="citation web cs1">Wakabayashi, Daisuke; Shane, Scott (June 1, 2018). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2018/06/01/technology/google-pentagon-project-maven.html">"Google Will Not Renew Pentagon Contract That Upset Employees"</a>. <i>nytimes.com</i>. The New York Times Company. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181016004020/https://www.nytimes.com/2018/06/01/technology/google-pentagon-project-maven.html">Archived</a> from the original on October 16, 2018<span class="reference-accessdate">. Retrieved <span class="nowrap">October 16,</span> 2018</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=nytimes.com&amp;rft.atitle=Google+Will+Not+Renew+Pentagon+Contract+That+Upset+Employees&amp;rft.date=2018-06-01&amp;rft.au=Wakabayashi%2C+Daisuke&amp;rft.au=Shane%2C+Scott&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2018%2F06%2F01%2Ftechnology%2Fgoogle-pentagon-project-maven.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-313">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-313" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.businessinsider.com/profile-reddit-de-google-community-2019-3">"Thousands of Reddit users are trying to delete Google from their lives, but they're finding it impossible because Google is everywhere"</a>. March 23, 2019. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190325123426/https://www.businessinsider.com/profile-reddit-de-google-community-2019-3/">Archived</a> from the original on March 25, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">April 24,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Thousands+of+Reddit+users+are+trying+to+delete+Google+from+their+lives%2C+but+they%27re+finding+it+impossible+because+Google+is+everywhere&amp;rft.date=2019-03-23&amp;rft_id=https%3A%2F%2Fwww.businessinsider.com%2Fprofile-reddit-de-google-community-2019-3&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-314">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-314" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKan2018" class="citation web cs1">Kan, Michael (July 25, 2018). <a rel="nofollow" class="external text" href="https://www.pcmag.com/news/mozilla-developer-claims-google-is-slowing-youtube-on-firefox">"Mozilla Developer Claims Google Is Slowing YouTube on Firefox"</a>. <i><a href="/wiki/PCMag" title="PCMag">PCMag</a></i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190813134744/https://www.pcmag.com/news/362696/mozilla-developer-claims-google-is-slowing-youtube-on-firefo">Archived</a> from the original on August 13, 2019.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=PCMag&amp;rft.atitle=Mozilla+Developer+Claims+Google+Is+Slowing+YouTube+on+Firefox&amp;rft.date=2018-07-25&amp;rft.aulast=Kan&amp;rft.aufirst=Michael&amp;rft_id=https%3A%2F%2Fwww.pcmag.com%2Fnews%2Fmozilla-developer-claims-google-is-slowing-youtube-on-firefox&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-315">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-315" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFCimpanu2019" class="citation news cs1">Cimpanu, Catalin (April 15, 2019). <a rel="nofollow" class="external text" href="https://www.zdnet.com/article/former-mozilla-exec-google-has-sabotaged-firefox-for-years/">"Former Mozilla exec: Google has sabotaged Firefox for years"</a>. <i><a href="/wiki/ZDNet" title="ZDNet">ZDNet</a></i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=ZDNet&amp;rft.atitle=Former+Mozilla+exec%3A+Google+has+sabotaged+Firefox+for+years&amp;rft.date=2019-04-15&amp;rft.aulast=Cimpanu&amp;rft.aufirst=Catalin&amp;rft_id=https%3A%2F%2Fwww.zdnet.com%2Farticle%2Fformer-mozilla-exec-google-has-sabotaged-firefox-for-years%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-316">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-316" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFCimpanu" class="citation web cs1">Cimpanu, Catalin. <a rel="nofollow" class="external text" href="https://www.zdnet.com/article/former-mozilla-exec-google-has-sabotaged-firefox-for-years/">"Former Mozilla exec: Google has sabotaged Firefox for years"</a>. <i>ZDNet</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190819235446/https://www.zdnet.com/article/former-mozilla-exec-google-has-sabotaged-firefox-for-years/">Archived</a> from the original on August 19, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">August 13,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=ZDNet&amp;rft.atitle=Former+Mozilla+exec%3A+Google+has+sabotaged+Firefox+for+years&amp;rft.aulast=Cimpanu&amp;rft.aufirst=Catalin&amp;rft_id=https%3A%2F%2Fwww.zdnet.com%2Farticle%2Fformer-mozilla-exec-google-has-sabotaged-firefox-for-years%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-317">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-317" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFCopeland2019" class="citation news cs1">Copeland, Rob (November 12, 2019). <a rel="nofollow" class="external text" href="https://www.wsj.com/articles/behind-googles-project-nightingale-a-health-data-gold-mine-of-50-million-patients-11573571867">"Google's 'Project Nightingale' Triggers Federal Inquiry"</a><span class="reference-accessdate">. Retrieved <span class="nowrap">November 18,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Google%27s+%27Project+Nightingale%27+Triggers+Federal+Inquiry&amp;rft.date=2019-11-12&amp;rft.aulast=Copeland&amp;rft.aufirst=Rob&amp;rft_id=https%3A%2F%2Fwww.wsj.com%2Farticles%2Fbehind-googles-project-nightingale-a-health-data-gold-mine-of-50-million-patients-11573571867&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-318">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-318" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFCopeland2019" class="citation news cs1">Copeland, Rob (November 11, 2019). <a rel="nofollow" class="external text" href="https://www.wsj.com/articles/google-s-secret-project-nightingale-gathers-personal-health-data-on-millions-of-americans-11573496790">"Google's 'Project Nightingale' Gathers Personal Health Data on Millions of Americans"</a><span class="reference-accessdate">. Retrieved <span class="nowrap">November 17,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Google%27s+%27Project+Nightingale%27+Gathers+Personal+Health+Data+on+Millions+of+Americans&amp;rft.date=2019-11-11&amp;rft.aulast=Copeland&amp;rft.aufirst=Rob&amp;rft_id=https%3A%2F%2Fwww.wsj.com%2Farticles%2Fgoogle-s-secret-project-nightingale-gathers-personal-health-data-on-millions-of-americans-11573496790&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-319">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-319" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFRosenblatt2015" class="citation news cs1">Rosenblatt, Joel (March 2, 2015). <a rel="nofollow" class="external text" href="https://www.bloomberg.com/news/articles/2015-03-02/tech-no-poaching-settlement-gets-judge-s-preliminary-approval">"Apple-Google $415 Million No-Poaching Accord Wins Approval"</a>. <a href="/wiki/Bloomberg_L.P." title="Bloomberg L.P.">Bloomberg L.P.</a> <a rel="nofollow" class="external text" href="https://web.archive.org/web/20160130214110/http://www.bloomberg.com/news/articles/2015-03-02/tech-no-poaching-settlement-gets-judge-s-preliminary-approval">Archived</a> from the original on January 30, 2016<span class="reference-accessdate">. Retrieved <span class="nowrap">January 24,</span> 2016</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Apple-Google+%24415+Million+No-Poaching+Accord+Wins+Approval&amp;rft.date=2015-03-02&amp;rft.aulast=Rosenblatt&amp;rft.aufirst=Joel&amp;rft_id=https%3A%2F%2Fwww.bloomberg.com%2Fnews%2Farticles%2F2015-03-02%2Ftech-no-poaching-settlement-gets-judge-s-preliminary-approval&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-320">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-320" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFKelion2017" class="citation web cs1">Kelion, Leo (June 27, 2017). <a rel="nofollow" class="external text" href="https://www.bbc.co.uk/news/technology-40406542">"Google hit with record EU fine over Shopping service"</a>. bbc.co.uk. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20170627100311/https://www.bbc.co.uk/news/technology-40406542">Archived</a> from the original on June 27, 2017<span class="reference-accessdate">. Retrieved <span class="nowrap">June 29,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google+hit+with+record+EU+fine+over+Shopping+service&amp;rft.pub=bbc.co.uk&amp;rft.date=2017-06-27&amp;rft.aulast=Kelion&amp;rft.aufirst=Leo&amp;rft_id=https%3A%2F%2Fwww.bbc.co.uk%2Fnews%2Ftechnology-40406542&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-321">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-321" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.newscientist.com/article/2139097-googles-e2-4bn-fine-is-small-change-the-eu-has-bigger-plans/">"Google's €2.4bn fine is small change – the EU has bigger plans"</a>. newscientist.com. <a rel="nofollow" class="external text" href="https://archive.today/20190124095546/https://www.newscientist.com/article/2139097-googles-e2-4bn-fine-is-small-change-the-eu-has-bigger-plans/">Archived</a> from the original on January 24, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">June 29,</span> 2017</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google%27s+%E2%82%AC2.4bn+fine+is+small+change+%E2%80%93+the+EU+has+bigger+plans&amp;rft.pub=newscientist.com&amp;rft_id=https%3A%2F%2Fwww.newscientist.com%2Farticle%2F2139097-googles-e2-4bn-fine-is-small-change-the-eu-has-bigger-plans%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-322">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-322" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.bbc.com/news/technology-51462397?intlink_from_url=https://www.bbc.com/news/technology&amp;link_location=live-reporting-story">"Google starts appeal against £2bn shopping fine"</a>. <i>BBC News</i>. February 12, 2020.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=BBC+News&amp;rft.atitle=Google+starts+appeal+against+%C2%A32bn+shopping+fine&amp;rft.date=2020-02-12&amp;rft_id=https%3A%2F%2Fwww.bbc.com%2Fnews%2Ftechnology-51462397%3Fintlink_from_url%3Dhttps%3A%2F%2Fwww.bbc.com%2Fnews%2Ftechnology%26link_location%3Dlive-reporting-story&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-323">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-323" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="http://europa.eu/rapid/press-release_IP-17-685_hr.htm">"Antitrust: Commission fines Google €4.34 billion for illegal practices regarding Android mobile devices to strengthen dominance of Google's search engine"</a>. <i>European Commission</i>. Bruxelles. July 18, 2018. <a rel="nofollow" class="external text" href="https://archive.today/20180718112553/http://europa.eu/rapid/press-release_IP-18-4581_en.htm">Archived</a> from the original on July 18, 2018.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=European+Commission&amp;rft.atitle=Antitrust%3A+Commission+fines+Google+%E2%82%AC4.34+billion+for+illegal+practices+regarding+Android+mobile+devices+to+strengthen+dominance+of+Google%27s+search+engine&amp;rft.date=2018-07-18&amp;rft_id=http%3A%2F%2Feuropa.eu%2Frapid%2Fpress-release_IP-17-685_hr.htm&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-324">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-324" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://apnews.com/f9797e4935c1464f8f6010793ded7c1d">"Google appeals $5 billion EU fine in Android antitrust case"</a>. <i><a href="/wiki/APNews.com" class="mw-redirect" title="APNews.com">APNews.com</a></i>. Bruxelles. October 10, 2018. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181010101238/https://apnews.com/f9797e4935c1464f8f6010793ded7c1d">Archived</a> from the original on October 10, 2018.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=APNews.com&amp;rft.atitle=Google+appeals+%245+billion+EU+fine+in+Android+antitrust+case&amp;rft.date=2018-10-10&amp;rft_id=https%3A%2F%2Fapnews.com%2Ff9797e4935c1464f8f6010793ded7c1d&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-325">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-325" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFFoo_Yun_Chee2014" class="citation news cs1">Foo Yun Chee (May 13, 2014). <a rel="nofollow" class="external text" href="https://www.reuters.com/article/us-eu-alphabet-inc-antitrust/google-challenges-record-5-billion-eu-antitrust-fine-idUSKCN1MJ2CA">"Google challenges record $5 billion EU antitrust fine"</a>. <i>Reuters</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20181222061539/https://www.reuters.com/article/us-eu-google-dataprotection/european-court-says-google-must-respect-right-to-be-forgotten-idUSBREA4C07120140513">Archived</a> from the original on December 22, 2018.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Reuters&amp;rft.atitle=Google+challenges+record+%245+billion+EU+antitrust+fine&amp;rft.date=2014-05-13&amp;rft.au=Foo+Yun+Chee&amp;rft_id=https%3A%2F%2Fwww.reuters.com%2Farticle%2Fus-eu-alphabet-inc-antitrust%2Fgoogle-challenges-record-5-billion-eu-antitrust-fine-idUSKCN1MJ2CA&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-326">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-326" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMurdock2020" class="citation news cs1">Murdock, Jason (August 5, 2020). <a rel="nofollow" class="external text" href="https://web.archive.org/web/20200806080428/https://www.newsweek.com/google-plus-privacy-bug-settlement-claim-money-1522967">"Google+ Settlement: How to Submit a Claim over Privacy Bug and Get a Payout"</a>. <i><a href="/wiki/Newsweek" title="Newsweek">Newsweek</a></i>. Archived from <a rel="nofollow" class="external text" href="https://www.newsweek.com/google-plus-privacy-bug-settlement-claim-money-1522967">the original</a> on August 6, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">August 5,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Newsweek&amp;rft.atitle=Google%2B+Settlement%3A+How+to+Submit+a+Claim+over+Privacy+Bug+and+Get+a+Payout&amp;rft.date=2020-08-05&amp;rft.aulast=Murdock&amp;rft.aufirst=Jason&amp;rft_id=https%3A%2F%2Fwww.newsweek.com%2Fgoogle-plus-privacy-bug-settlement-claim-money-1522967&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-327">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-327" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFGraham2020" class="citation news cs1">Graham, Jefferson (August 4, 2020). <a rel="nofollow" class="external text" href="https://web.archive.org/web/20200806014134/https://www.usatoday.com/story/tech/2020/08/04/google-privacy-settlement-how-much-money-how-to-get/3290508001/">"Did you use Google+? You may be owed some money from class-action privacy settlement"</a>. <i><a href="/wiki/USA_Today" title="USA Today">USA Today</a></i>. Archived from <a rel="nofollow" class="external text" href="https://www.usatoday.com/story/tech/2020/08/04/google-privacy-settlement-how-much-money-how-to-get/3290508001/">the original</a> on August 6, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">August 5,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=USA+Today&amp;rft.atitle=Did+you+use+Google%2B%3F+You+may+be+owed+some+money+from+class-action+privacy+settlement&amp;rft.date=2020-08-04&amp;rft.aulast=Graham&amp;rft.aufirst=Jefferson&amp;rft_id=https%3A%2F%2Fwww.usatoday.com%2Fstory%2Ftech%2F2020%2F08%2F04%2Fgoogle-privacy-settlement-how-much-money-how-to-get%2F3290508001%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-328">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-328" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/20200806003928/https://www.courtlistener.com/docket/7999009/in-re-google-plus-profile-litigation/">"In re Google Plus Profile Litigation District Court ND of California"</a>. <i>courtlistener.com</i>. <a href="/wiki/Free_Law_Project" title="Free Law Project">Free Law Project</a>. July 22, 2020. Archived from <a rel="nofollow" class="external text" href="https://www.courtlistener.com/docket/7999009/in-re-google-plus-profile-litigation/">the original</a> on August 6, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">August 5,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=courtlistener.com&amp;rft.atitle=In+re+Google+Plus+Profile+Litigation+District+Court+ND+of+California&amp;rft.date=2020-07-22&amp;rft_id=https%3A%2F%2Fwww.courtlistener.com%2Fdocket%2F7999009%2Fin-re-google-plus-profile-litigation%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-329">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-329" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFFox2019" class="citation web cs1">Fox, Chris (January 21, 2019). <a rel="nofollow" class="external text" href="https://www.bbc.com/news/technology-46944696">"Google hit with £44m GDPR fine"</a>. <i>BBC</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190121231240/https://www.bbc.com/news/technology-46944696">Archived</a> from the original on January 21, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">January 22,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=BBC&amp;rft.atitle=Google+hit+with+%C2%A344m+GDPR+fine&amp;rft.date=2019-01-21&amp;rft.aulast=Fox&amp;rft.aufirst=Chris&amp;rft_id=https%3A%2F%2Fwww.bbc.com%2Fnews%2Ftechnology-46944696&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-330">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-330" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.cnn.com/2019/03/20/tech/google-eu-antitrust/index.html">"Europe hits Google with a third, $1.7 billion antitrust fine"</a>. <i>CNN</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190320133734/https://www.cnn.com/2019/03/20/tech/google-eu-antitrust/index.html">Archived</a> from the original on March 20, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">March 21,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=CNN&amp;rft.atitle=Europe+hits+Google+with+a+third%2C+%241.7+billion+antitrust+fine&amp;rft_id=https%3A%2F%2Fwww.cnn.com%2F2019%2F03%2F20%2Ftech%2Fgoogle-eu-antitrust%2Findex.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-331">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-331" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFReid" class="citation web cs1">Reid, David. <a rel="nofollow" class="external text" href="https://www.cnbc.com/2019/03/20/eu-vestager-hits-google-with-fine-for.html">"EU regulators hit Google with $1.7 billion fine for blocking ad rivals"</a>. <i>CNBC.com</i>. <a rel="nofollow" class="external text" href="https://web.archive.org/web/20190320155204/https://www.cnbc.com/2019/03/20/eu-vestager-hits-google-with-fine-for.html">Archived</a> from the original on March 20, 2019<span class="reference-accessdate">. Retrieved <span class="nowrap">March 20,</span> 2019</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=CNBC.com&amp;rft.atitle=EU+regulators+hit+Google+with+%241.7+billion+fine+for+blocking+ad+rivals&amp;rft.aulast=Reid&amp;rft.aufirst=David&amp;rft_id=https%3A%2F%2Fwww.cnbc.com%2F2019%2F03%2F20%2Feu-vestager-hits-google-with-fine-for.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-332">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-332" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation news cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/20200730020044/https://www.bbc.com/news/business-53583941">"Tech bosses grilled over claims of 'harmful' power"</a>. <i><a href="/wiki/BBC_News" title="BBC News">BBC News</a></i>. July 30, 2020. Archived from <a rel="nofollow" class="external text" href="https://www.bbc.com/news/business-53583941">the original</a> on July 30, 2020<span class="reference-accessdate">. Retrieved <span class="nowrap">July 30,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=BBC+News&amp;rft.atitle=Tech+bosses+grilled+over+claims+of+%27harmful%27+power&amp;rft.date=2020-07-30&amp;rft_id=https%3A%2F%2Fwww.bbc.com%2Fnews%2Fbusiness-53583941&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-333">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-333" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.npr.org/2020/10/06/920882893/how-are-apple-amazon-facebook-google-monopolies-house-report-counts-the-ways">"How Are Apple, Amazon, Facebook, Google Monopolies? House Report Counts The Ways"</a>. <i>NPR.org</i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=NPR.org&amp;rft.atitle=How+Are+Apple%2C+Amazon%2C+Facebook%2C+Google+Monopolies%3F+House+Report+Counts+The+Ways&amp;rft_id=https%3A%2F%2Fwww.npr.org%2F2020%2F10%2F06%2F920882893%2Fhow-are-apple-amazon-facebook-google-monopolies-house-report-counts-the-ways&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-334">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-334" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMcCabeKang2020" class="citation web cs1">McCabe, David; Kang, Cecilia (October 20, 2020). <a rel="nofollow" class="external text" href="https://www.nytimes.com/2020/10/20/technology/google-antitrust.html">"U.S. Accuses Google of Illegally Protecting Monopoly"</a>. <i><a href="/wiki/The_New_York_Times" title="The New York Times">The New York Times</a></i><span class="reference-accessdate">. Retrieved <span class="nowrap">October 20,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=The+New+York+Times&amp;rft.atitle=U.S.+Accuses+Google+of+Illegally+Protecting+Monopoly&amp;rft.date=2020-10-20&amp;rft.aulast=McCabe&amp;rft.aufirst=David&amp;rft.au=Kang%2C+Cecilia&amp;rft_id=https%3A%2F%2Fwww.nytimes.com%2F2020%2F10%2F20%2Ftechnology%2Fgoogle-antitrust.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-335">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-335" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFAllyn_(NPR)" class="citation web cs1">Allyn (NPR), Bobby. <a rel="nofollow" class="external text" href="https://www.documentcloud.org/documents/7273448-DOC.html">"DOC"</a>. <i>www.documentcloud.org</i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=www.documentcloud.org&amp;rft.atitle=DOC&amp;rft.aulast=Allyn+%28NPR%29&amp;rft.aufirst=Bobby&amp;rft_id=https%3A%2F%2Fwww.documentcloud.org%2Fdocuments%2F7273448-DOC.html&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-336">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-336" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://www.npr.org/2020/10/22/926290942/google-paid-apple-billions-to-dominate-search-on-iphones-justice-department-says">"Google Paid Apple Billions To Dominate Search On iPhones, Justice Department Says"</a>. <i>NPR.org</i>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=unknown&amp;rft.jtitle=NPR.org&amp;rft.atitle=Google+Paid+Apple+Billions+To+Dominate+Search+On+iPhones%2C+Justice+Department+Says&amp;rft_id=https%3A%2F%2Fwww.npr.org%2F2020%2F10%2F22%2F926290942%2Fgoogle-paid-apple-billions-to-dominate-search-on-iphones-justice-department-says&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-337">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-337" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFNgo2019" class="citation news cs1">Ngo, Keach Hagey and Vivien (November 7, 2019). <a rel="nofollow" class="external text" href="https://www.wsj.com/articles/how-google-edged-out-rivals-and-built-the-worlds-dominant-ad-machine-a-visual-guide-11573142071">"How Google Edged Out Rivals and Built the World's Dominant Ad Machine: A Visual Guide"</a>. <i>Wall Street Journal</i>. <a href="/wiki/ISSN_(identifier)" class="mw-redirect" title="ISSN (identifier)">ISSN</a>&nbsp;<a rel="nofollow" class="external text" href="//www.worldcat.org/issn/0099-9660">0099-9660</a><span class="reference-accessdate">. Retrieved <span class="nowrap">December 25,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Wall+Street+Journal&amp;rft.atitle=How+Google+Edged+Out+Rivals+and+Built+the+World%27s+Dominant+Ad+Machine%3A+A+Visual+Guide&amp;rft.date=2019-11-07&amp;rft.issn=0099-9660&amp;rft.aulast=Ngo&amp;rft.aufirst=Keach+Hagey+and+Vivien&amp;rft_id=https%3A%2F%2Fwww.wsj.com%2Farticles%2Fhow-google-edged-out-rivals-and-built-the-worlds-dominant-ad-machine-a-visual-guide-11573142071&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-338">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-338" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFMcKinnon2020" class="citation news cs1">McKinnon, Ryan Tracy and John D. (December 22, 2020). <a rel="nofollow" class="external text" href="https://www.wsj.com/articles/google-facebook-agreed-to-team-up-against-possible-antitrust-action-draft-lawsuit-says-11608612219">"WSJ News Exclusive | Google, Facebook Agreed to Team Up Against Possible Antitrust Action, Draft Lawsuit Says"</a>. <i>Wall Street Journal</i>. <a href="/wiki/ISSN_(identifier)" class="mw-redirect" title="ISSN (identifier)">ISSN</a>&nbsp;<a rel="nofollow" class="external text" href="//www.worldcat.org/issn/0099-9660">0099-9660</a><span class="reference-accessdate">. Retrieved <span class="nowrap">December 25,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Wall+Street+Journal&amp;rft.atitle=WSJ+News+Exclusive+%7C+Google%2C+Facebook+Agreed+to+Team+Up+Against+Possible+Antitrust+Action%2C+Draft+Lawsuit+Says&amp;rft.date=2020-12-22&amp;rft.issn=0099-9660&amp;rft.aulast=McKinnon&amp;rft.aufirst=Ryan+Tracy+and+John+D.&amp;rft_id=https%3A%2F%2Fwww.wsj.com%2Farticles%2Fgoogle-facebook-agreed-to-team-up-against-possible-antitrust-action-draft-lawsuit-says-11608612219&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
            <li id="cite_note-339">
               <span class="mw-cite-backlink"><b><a href="#cite_ref-339" aria-label="Jump up" title="Jump up">^</a></b></span> 
               <span class="reference-text">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
                  <cite id="CITEREFTracy2020" class="citation news cs1">Tracy, John D. McKinnon and Ryan (December 16, 2020). <a rel="nofollow" class="external text" href="https://www.wsj.com/articles/states-sue-google-over-digital-ad-practices-11608146817">"Ten States Sue Google, Alleging Deal With Facebook to Rig Online Ad Market"</a>. <i>Wall Street Journal</i>. <a href="/wiki/ISSN_(identifier)" class="mw-redirect" title="ISSN (identifier)">ISSN</a>&nbsp;<a rel="nofollow" class="external text" href="//www.worldcat.org/issn/0099-9660">0099-9660</a><span class="reference-accessdate">. Retrieved <span class="nowrap">December 25,</span> 2020</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Wall+Street+Journal&amp;rft.atitle=Ten+States+Sue+Google%2C+Alleging+Deal+With+Facebook+to+Rig+Online+Ad+Market&amp;rft.date=2020-12-16&amp;rft.issn=0099-9660&amp;rft.aulast=Tracy&amp;rft.aufirst=John+D.+McKinnon+and+Ryan&amp;rft_id=https%3A%2F%2Fwww.wsj.com%2Farticles%2Fstates-sue-google-over-digital-ad-practices-11608146817&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
               </span>
            </li>
         </ol>
      </div>
   </div>
   <h2><span class="mw-headline" id="Further_reading">Further reading</span></h2>
   <ul>
      <li>
         <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
         <cite class="citation book cs1"><a href="/wiki/Michael_J._Saylor" title="Michael J. Saylor">Saylor, Michael</a> (2012). <i>The Mobile Wave: How Mobile Intelligence Will Change Everything</i>. Perseus Books/Vanguard Press. <a href="/wiki/ISBN_(identifier)" class="mw-redirect" title="ISBN (identifier)">ISBN</a>&nbsp;<a href="/wiki/Special:BookSources/978-1593157203" title="Special:BookSources/978-1593157203"><bdi>978-1593157203</bdi></a>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=book&amp;rft.btitle=The+Mobile+Wave%3A+How+Mobile+Intelligence+Will+Change+Everything&amp;rft.pub=Perseus+Books%2FVanguard+Press&amp;rft.date=2012&amp;rft.isbn=978-1593157203&amp;rft.aulast=Saylor&amp;rft.aufirst=Michael&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
      </li>
      <li>Vaidhyanathan, Siya. 2011. <i><a rel="nofollow" class="external text" href="https://www.jstor.org/stable/10.1525/j.ctt1pn9z8">The Googlization of Everything: (And Why We Should Worry)</a></i>. University of California Press.</li>
   </ul>
   <h2><span class="mw-headline" id="External_links">External links</span></h2>
   <div role="navigation" aria-labelledby="sister-projects" class="metadata plainlinks sistersitebox plainlist mbox-small" style="border:1px solid #aaa;padding:0;background:#f9f9f9">
      <div style="padding:0.75em 0;text-align:center"><b style="display:block">Google</b>at Wikipedia's <a href="/wiki/Wikipedia:Wikimedia_sister_projects" title="Wikipedia:Wikimedia sister projects"><span id="sister-projects">sister projects</span></a></div>
      <ul style="border-top:1px solid #aaa;padding:0.75em 0;width:217px;margin:0 auto">
         <li style="min-height:31px"><span style="display:inline-block;width:31px;line-height:31px;vertical-align:middle;text-align:center"><img alt="" src="//upload.wikimedia.org/wikipedia/en/thumb/0/06/Wiktionary-logo-v2.svg/27px-Wiktionary-logo-v2.svg.png" decoding="async" width="27" height="27" style="vertical-align: middle" srcset="//upload.wikimedia.org/wikipedia/en/thumb/0/06/Wiktionary-logo-v2.svg/41px-Wiktionary-logo-v2.svg.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/0/06/Wiktionary-logo-v2.svg/54px-Wiktionary-logo-v2.svg.png 2x" data-file-width="391" data-file-height="391"></span><span style="display:inline-block;margin-left:4px;width:182px;vertical-align:middle"><a href="https://en.wiktionary.org/wiki/Special:Search/Google" class="extiw" title="wikt:Special:Search/Google">Definitions</a> from Wiktionary</span></li>
         <li style="min-height:31px"><span style="display:inline-block;width:31px;line-height:31px;vertical-align:middle;text-align:center"><img alt="" src="//upload.wikimedia.org/wikipedia/en/thumb/4/4a/Commons-logo.svg/20px-Commons-logo.svg.png" decoding="async" width="20" height="27" style="vertical-align: middle" srcset="//upload.wikimedia.org/wikipedia/en/thumb/4/4a/Commons-logo.svg/30px-Commons-logo.svg.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/4/4a/Commons-logo.svg/40px-Commons-logo.svg.png 2x" data-file-width="1024" data-file-height="1376"></span><span style="display:inline-block;margin-left:4px;width:182px;vertical-align:middle"><a href="https://commons.wikimedia.org/wiki/Google" class="extiw" title="c:Google">Media</a> from Wikimedia Commons</span></li>
         <li style="min-height:31px"><span style="display:inline-block;width:31px;line-height:31px;vertical-align:middle;text-align:center"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/2/24/Wikinews-logo.svg/27px-Wikinews-logo.svg.png" decoding="async" width="27" height="15" style="vertical-align: middle" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/2/24/Wikinews-logo.svg/41px-Wikinews-logo.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/2/24/Wikinews-logo.svg/54px-Wikinews-logo.svg.png 2x" data-file-width="759" data-file-height="415"></span><span style="display:inline-block;margin-left:4px;width:182px;vertical-align:middle"><a href="https://en.wikinews.org/wiki/Category:Google" class="extiw" title="n:Category:Google">News</a> from Wikinews</span></li>
         <li style="min-height:31px"><span style="display:inline-block;width:31px;line-height:31px;vertical-align:middle;text-align:center"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Wikiquote-logo.svg/23px-Wikiquote-logo.svg.png" decoding="async" width="23" height="27" style="vertical-align: middle" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Wikiquote-logo.svg/35px-Wikiquote-logo.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Wikiquote-logo.svg/46px-Wikiquote-logo.svg.png 2x" data-file-width="300" data-file-height="355"></span><span style="display:inline-block;margin-left:4px;width:182px;vertical-align:middle"><a href="https://en.wikiquote.org/wiki/Google" class="extiw" title="q:Google">Quotations</a> from Wikiquote</span></li>
         <li style="min-height:31px"><span style="display:inline-block;width:31px;line-height:31px;vertical-align:middle;text-align:center"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Wikibooks-logo.svg/27px-Wikibooks-logo.svg.png" decoding="async" width="27" height="27" style="vertical-align: middle" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Wikibooks-logo.svg/41px-Wikibooks-logo.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Wikibooks-logo.svg/54px-Wikibooks-logo.svg.png 2x" data-file-width="300" data-file-height="300"></span><span style="display:inline-block;margin-left:4px;width:182px;vertical-align:middle"><a href="https://en.wikibooks.org/wiki/Google_Services_And_Products" class="extiw" title="b:Google Services And Products">Textbooks</a> from Wikibooks</span></li>
         <li style="min-height:31px"><span style="display:inline-block;width:31px;line-height:31px;vertical-align:middle;text-align:center"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Wikiversity_logo_2017.svg/27px-Wikiversity_logo_2017.svg.png" decoding="async" width="27" height="22" style="vertical-align: middle" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Wikiversity_logo_2017.svg/41px-Wikiversity_logo_2017.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Wikiversity_logo_2017.svg/54px-Wikiversity_logo_2017.svg.png 2x" data-file-width="626" data-file-height="512"></span><span style="display:inline-block;margin-left:4px;width:182px;vertical-align:middle"><a href="https://en.wikiversity.org/wiki/Google" class="extiw" title="v:Google">Resources</a> from Wikiversity</span></li>
         <li style="min-height:31px"><span style="display:inline-block;width:31px;line-height:31px;vertical-align:middle;text-align:center"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Wikidata-logo.svg/27px-Wikidata-logo.svg.png" decoding="async" width="27" height="15" style="vertical-align: middle" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Wikidata-logo.svg/41px-Wikidata-logo.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Wikidata-logo.svg/54px-Wikidata-logo.svg.png 2x" data-file-width="1050" data-file-height="590"></span><span style="display:inline-block;margin-left:4px;width:182px;vertical-align:middle"><a href="https://www.wikidata.org/wiki/Q95" class="extiw" title="d:Q95">Data</a> from Wikidata</span></li>
         <li style="min-height:31px"><span style="display:inline-block;width:31px;line-height:31px;vertical-align:middle;text-align:center"><img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/7/75/Wikimedia_Community_Logo.svg/27px-Wikimedia_Community_Logo.svg.png" decoding="async" width="27" height="27" style="vertical-align: middle" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/7/75/Wikimedia_Community_Logo.svg/41px-Wikimedia_Community_Logo.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/7/75/Wikimedia_Community_Logo.svg/54px-Wikimedia_Community_Logo.svg.png 2x" data-file-width="900" data-file-height="900"></span><span style="display:inline-block;margin-left:4px;width:182px;vertical-align:middle"><a href="https://meta.wikimedia.org/wiki/Google" class="extiw" title="m:Google">Discussion</a> from Meta-Wiki</span></li>
      </ul>
   </div>
   <ul>
      <li>
         <span class="official-website"><span class="url"><a rel="nofollow" class="external text" href="https://www.google.com/">Official website</a></span></span> <a href="https://www.wikidata.org/wiki/Q95#P856" title="Edit this at Wikidata"><img alt="Edit this at Wikidata" src="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/10px-OOjs_UI_icon_edit-ltr-progressive.svg.png" decoding="async" width="10" height="10" style="vertical-align: text-top" srcset="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/15px-OOjs_UI_icon_edit-ltr-progressive.svg.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/20px-OOjs_UI_icon_edit-ltr-progressive.svg.png 2x" data-file-width="20" data-file-height="20"></a>
         <ul>
            <li><a rel="nofollow" class="external text" href="https://www.google.com/about/company/facts/management">Corporate homepage</a></li>
         </ul>
      </li>
      <li>
         <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
         <cite class="citation web cs1"><a rel="nofollow" class="external text" href="https://web.archive.org/web/19981111183552/http://google.stanford.edu/">"Google website"</a>. Archived from <a rel="nofollow" class="external text" href="http://google.stanford.edu/">the original</a> on November 11, 1998<span class="reference-accessdate">. Retrieved <span class="nowrap">September 28,</span> 2010</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Google+website&amp;rft_id=http%3A%2F%2Fgoogle.stanford.edu%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
      </li>
      <li>
         <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r999302996">
         <cite id="CITEREFCarr2006" class="citation journal cs1">Carr, David F. (2006). <a rel="nofollow" class="external text" href="http://www.baselinemag.com/c/a/Infrastructure/How-Google-Works-1">"How Google Works"</a>. <i>Baseline Magazine</i>. <b>6</b> (6).</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Baseline+Magazine&amp;rft.atitle=How+Google+Works&amp;rft.volume=6&amp;rft.issue=6&amp;rft.date=2006&amp;rft.aulast=Carr&amp;rft.aufirst=David+F.&amp;rft_id=http%3A%2F%2Fwww.baselinemag.com%2Fc%2Fa%2FInfrastructure%2FHow-Google-Works-1&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AGoogle" class="Z3988"></span>
      </li>
      <li><a rel="nofollow" class="external text" href="https://www.crunchbase.com/organization/google">Google</a> at <a href="/wiki/Crunchbase" title="Crunchbase">Crunchbase</a></li>
      <li><a rel="nofollow" class="external text" href="https://opencorporates.com/corporate_groupings/Google">Google companies</a> grouped at <a href="/wiki/OpenCorporates" title="OpenCorporates">OpenCorporates</a></li>
      <li>
         Business data for Google, Inc.: 
         <div class="hlist hlist-separated inline">
            <ul>
               <li><a rel="nofollow" class="external text" href="https://www.bloomberg.com/quote/GOOG:US">Bloomberg</a></li>
               <li><a rel="nofollow" class="external text" href="https://www.reuters.com/finance/stocks/overview?symbol=GOOG.OQ">Reuters</a></li>
               <li><a rel="nofollow" class="external text" href="https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;CIK=1288776">SEC filings</a></li>
               <li><a rel="nofollow" class="external text" href="https://www.nasdaq.com/symbol/GOOG">Nasdaq</a></li>
            </ul>
         </div>
      </li>
   </ul>
   <div role="navigation" class="navbox" aria-labelledby="Google" style="padding:3px">
      <table class="nowraplinks hlist mw-collapsible mw-collapsed navbox-inner mw-made-collapsible" style="border-spacing:0;background:transparent;color:inherit">
         <tbody>
            <tr>
               <th scope="col" class="navbox-title" colspan="3">
                  <span class="mw-collapsible-toggle mw-collapsible-toggle-default mw-collapsible-toggle-collapsed" role="button" tabindex="0" aria-expanded="false"><a class="mw-collapsible-text">show</a></span>
                  <style data-mw-deduplicate="TemplateStyles:r992953826">.mw-parser-output .navbar{display:inline;font-size:88%;font-weight:normal}.mw-parser-output .navbar-collapse{float:left;text-align:left}.mw-parser-output .navbar-boxtext{word-spacing:0}.mw-parser-output .navbar ul{display:inline-block;white-space:nowrap;line-height:inherit}.mw-parser-output .navbar-brackets::before{margin-right:-0.125em;content:"[ "}.mw-parser-output .navbar-brackets::after{margin-left:-0.125em;content:" ]"}.mw-parser-output .navbar li{word-spacing:-0.125em}.mw-parser-output .navbar-mini abbr{font-variant:small-caps;border-bottom:none;text-decoration:none;cursor:inherit}.mw-parser-output .navbar-ct-full{font-size:114%;margin:0 7em}.mw-parser-output .navbar-ct-mini{font-size:114%;margin:0 4em}.mw-parser-output .infobox .navbar{font-size:100%}.mw-parser-output .navbox .navbar{display:block;font-size:100%}.mw-parser-output .navbox-title .navbar{float:left;text-align:left;margin-right:0.5em}</style>
                  <div class="navbar plainlinks hlist navbar-mini">
                     <ul>
                        <li class="nv-view"><a href="/wiki/Template:Google_LLC" title="Template:Google LLC"><abbr title="View this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">v</abbr></a></li>
                        <li class="nv-talk"><a href="/wiki/Template_talk:Google_LLC" title="Template talk:Google LLC"><abbr title="Discuss this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">t</abbr></a></li>
                        <li class="nv-edit"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Template:Google_LLC&amp;action=edit"><abbr title="Edit this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">e</abbr></a></li>
                     </ul>
                  </div>
                  <div id="Google" style="font-size:114%;margin:0 4em"><a class="mw-selflink selflink">Google</a></div>
               </th>
            </tr>
            <tr style="display: none;">
               <td class="navbox-abovebelow" colspan="3">
                  <div id="*_Alphabet_Inc._*_History_*_Outline_*_List_of_products_*_List_of_Android_apps_*_List_of_Easter_eggs_**_List_of_April_Fool&amp;#039;s_Day_jokes_*_List_of_mergers_and_acquisitions">
                     <ul>
                        <li><a href="/wiki/Alphabet_Inc." title="Alphabet Inc.">Alphabet Inc.</a></li>
                        <li><a href="/wiki/History_of_Google" title="History of Google">History</a></li>
                        <li><a href="/wiki/Outline_of_Google" title="Outline of Google">Outline</a></li>
                        <li><a href="/wiki/List_of_Google_products" title="List of Google products">List of products</a></li>
                        <li><a href="/wiki/List_of_Android_apps_by_Google" title="List of Android apps by Google">List of Android apps</a></li>
                        <li>
                           <a href="/wiki/List_of_Google_Easter_eggs" title="List of Google Easter eggs">List of Easter eggs</a>
                           <ul>
                              <li><a href="/wiki/List_of_Google_April_Fools%27_Day_jokes" title="List of Google April Fools' Day jokes">List of April Fool's Day jokes</a></li>
                           </ul>
                        </li>
                        <li><a href="/wiki/List_of_mergers_and_acquisitions_by_Alphabet" title="List of mergers and acquisitions by Alphabet">List of mergers and acquisitions</a></li>
                     </ul>
                  </div>
               </td>
            </tr>
            <tr style="display: none;">
               <th scope="row" class="navbox-group" style="width:1%">Company</th>
               <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                  <div style="padding:0em 0.25em"></div>
                  <table class="nowraplinks navbox-subgroup" style="border-spacing:0">
                     <tbody>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Divisions and<br> real estates</th>
                           <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li><a href="/wiki/Google_Ads" title="Google Ads">Ads</a></li>
                                    <li><a href="/wiki/Google_AI" title="Google AI">AI</a></li>
                                    <li><a href="/wiki/Android_(operating_system)" title="Android (operating system)">Android</a></li>
                                    <li><a href="/wiki/Google_China" title="Google China">China</a></li>
                                    <li><a href="/wiki/Google_Chrome" title="Google Chrome">Chrome</a></li>
                                    <li><a href="/wiki/Google_Cloud_Platform" title="Google Cloud Platform">Cloud</a></li>
                                    <li><a href="/wiki/Google_Glass" title="Google Glass">Glass</a></li>
                                    <li>
                                       <a href="/wiki/Google.org" title="Google.org">Google.org</a>
                                       <ul>
                                          <li><a href="/wiki/Google_Crisis_Response" title="Google Crisis Response">Crisis Response</a></li>
                                          <li><a href="/wiki/Google_Public_Alerts" title="Google Public Alerts">Public Alerts</a></li>
                                          <li><a href="/wiki/RechargeIT" title="RechargeIT">RechargeIT</a></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_Health" title="Google Health">Health</a></li>
                                    <li><a href="/wiki/Google_Maps" title="Google Maps">Maps</a></li>
                                    <li><a href="/wiki/Google_Nest" title="Google Nest">Nest</a></li>
                                    <li><a href="/wiki/Google_Pixel" title="Google Pixel">Pixel</a></li>
                                    <li>
                                       Registry
                                       <ul>
                                          <li><a href="/wiki/.google" title=".google">.google</a></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_Search" title="Google Search">Search</a></li>
                                    <li>
                                       <a href="/wiki/Google_Stadia" title="Google Stadia">Stadia</a>
                                       <ul>
                                          <li><i><a href="/wiki/Google_Stadia#Stadia_Games_and_Entertainment" title="Google Stadia">Games and Entertainment</a></i></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/YouTube" title="YouTube">YouTube</a></li>
                                    <li>
                                       Real estates
                                       <ul>
                                          <li><a href="/wiki/111_Eighth_Avenue" title="111 Eighth Avenue">111 Eighth Avenue</a></li>
                                          <li><i><a href="/wiki/Google_barges" title="Google barges">Barges</a></i></li>
                                          <li><a href="/wiki/Chelsea_Market" title="Chelsea Market">Chelsea Market</a></li>
                                          <li><a href="/wiki/Google_data_centers" title="Google data centers">Data centers</a></li>
                                          <li><a href="/wiki/Googleplex" title="Googleplex">Googleplex</a></li>
                                          <li><a href="/wiki/YouTube_Space" title="YouTube Space">YouTube Space</a></li>
                                       </ul>
                                    </li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Category:Google_employees" title="Category:Google employees">People</a></th>
                           <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em"></div>
                              <table class="nowraplinks navbox-subgroup" style="border-spacing:0">
                                 <tbody>
                                    <tr>
                                       <th scope="row" class="navbox-group" style="width:1%">Current</th>
                                       <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                          <div style="padding:0em 0.25em">
                                             <ul>
                                                <li><a href="/wiki/Krishna_Bharat" title="Krishna Bharat">Krishna Bharat</a></li>
                                                <li><a href="/wiki/Vint_Cerf" title="Vint Cerf">Vint Cerf</a></li>
                                                <li><a href="/wiki/Jeff_Dean" title="Jeff Dean">Jeff Dean</a></li>
                                                <li><a href="/wiki/John_Doerr" title="John Doerr">John Doerr</a></li>
                                                <li><a href="/wiki/Sanjay_Ghemawat" title="Sanjay Ghemawat">Sanjay Ghemawat</a></li>
                                                <li><a href="/wiki/Al_Gore" title="Al Gore">Al Gore</a></li>
                                                <li><a href="/wiki/John_L._Hennessy" title="John L. Hennessy">John L. Hennessy</a></li>
                                                <li><a href="/wiki/Urs_H%C3%B6lzle" title="Urs Hölzle">Urs Hölzle</a></li>
                                                <li><a href="/wiki/Salar_Kamangar" title="Salar Kamangar">Salar Kamangar</a></li>
                                                <li><a href="/wiki/Ray_Kurzweil" title="Ray Kurzweil">Ray Kurzweil</a></li>
                                                <li><a href="/wiki/Ann_Mather" title="Ann Mather">Ann Mather</a></li>
                                                <li><a href="/wiki/Alan_Mulally" title="Alan Mulally">Alan Mulally</a></li>
                                                <li><a href="/wiki/Sundar_Pichai" title="Sundar Pichai">Sundar Pichai</a> (CEO)</li>
                                                <li><a href="/wiki/Ruth_Porat" title="Ruth Porat">Ruth Porat</a> (CFO)</li>
                                                <li><a href="/wiki/Rajen_Sheth" title="Rajen Sheth">Rajen Sheth</a></li>
                                                <li><a href="/wiki/Hal_Varian" title="Hal Varian">Hal Varian</a></li>
                                                <li><a href="/wiki/Susan_Wojcicki" title="Susan Wojcicki">Susan Wojcicki</a></li>
                                             </ul>
                                          </div>
                                       </td>
                                    </tr>
                                    <tr>
                                       <th scope="row" class="navbox-group" style="width:1%">Former</th>
                                       <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                          <div style="padding:0em 0.25em">
                                             <ul>
                                                <li><a href="/wiki/Andy_Bechtolsheim" title="Andy Bechtolsheim">Andy Bechtolsheim</a></li>
                                                <li><a href="/wiki/Sergey_Brin" title="Sergey Brin">Sergey Brin</a> (Founder)</li>
                                                <li><a href="/wiki/David_Cheriton" title="David Cheriton">David Cheriton</a></li>
                                                <li><a href="/wiki/Matt_Cutts" title="Matt Cutts">Matt Cutts</a></li>
                                                <li><a href="/wiki/David_Drummond_(businessman)" title="David Drummond (businessman)">David Drummond</a></li>
                                                <li><a href="/wiki/Alan_Eustace" title="Alan Eustace">Alan Eustace</a></li>
                                                <li><a href="/wiki/Timnit_Gebru" title="Timnit Gebru">Timnit Gebru</a></li>
                                                <li><a href="/wiki/Omid_Kordestani" title="Omid Kordestani">Omid Kordestani</a></li>
                                                <li><a href="/wiki/Paul_Otellini" title="Paul Otellini">Paul Otellini</a></li>
                                                <li><a href="/wiki/Larry_Page" title="Larry Page">Larry Page</a> (Founder)</li>
                                                <li><a href="/wiki/Patrick_Pichette" title="Patrick Pichette">Patrick Pichette</a></li>
                                                <li><a href="/wiki/Eric_Schmidt" title="Eric Schmidt">Eric Schmidt</a></li>
                                                <li><a href="/wiki/Ram_Shriram" title="Ram Shriram">Ram Shriram</a></li>
                                                <li><a href="/wiki/Amit_Singhal" title="Amit Singhal">Amit Singhal</a></li>
                                                <li><a href="/wiki/Shirley_M._Tilghman" title="Shirley M. Tilghman">Shirley M. Tilghman</a></li>
                                                <li><a href="/wiki/Rachel_Whetstone" title="Rachel Whetstone">Rachel Whetstone</a></li>
                                             </ul>
                                          </div>
                                       </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <div></div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Design and<br> typography</th>
                           <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li>
                                       Fonts
                                       <ul>
                                          <li><a href="/wiki/Croscore_fonts" title="Croscore fonts">Croscore</a></li>
                                          <li><a href="/wiki/Product_Sans" title="Product Sans">Google Sans</a></li>
                                          <li><a href="/wiki/Noto_fonts" title="Noto fonts">Noto</a></li>
                                          <li><a href="/wiki/Product_Sans" title="Product Sans">Product Sans</a></li>
                                          <li><a href="/wiki/Roboto" title="Roboto">Roboto</a></li>
                                       </ul>
                                    </li>
                                    <li>
                                       <a href="/wiki/Google_logo" title="Google logo">Logo</a>
                                       <ul>
                                          <li><a href="/wiki/Google_Doodle" title="Google Doodle">Doodle</a></li>
                                          <li><a href="/wiki/Google_logo#Favicon" title="Google logo">Favicon</a></li>
                                       </ul>
                                    </li>
                                    <li>
                                       <a href="/wiki/Material_Design" title="Material Design">Material Design</a>
                                       <ul>
                                          <li><a href="/wiki/Comparison_of_Material_Design_implementations" title="Comparison of Material Design implementations">comparison of implementations</a></li>
                                       </ul>
                                    </li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Events and <br>initiatives</th>
                           <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li>
                                       Android
                                       <ul>
                                          <li><a href="/wiki/Android_Developer_Challenge" title="Android Developer Challenge">Developer Challenge</a></li>
                                          <li><a href="/wiki/Android_Developer_Day" title="Android Developer Day">Developer Day</a></li>
                                          <li><a href="/wiki/Android_Developer_Lab" title="Android Developer Lab">Developer Lab</a></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_Code-in" title="Google Code-in">Code-in</a></li>
                                    <li><a href="/wiki/Google_Code_Jam" title="Google Code Jam">Code Jam</a></li>
                                    <li><a href="/wiki/Google_Developer_Day" title="Google Developer Day">Developer Day</a></li>
                                    <li><a href="/wiki/Google_Developers_Live" title="Google Developers Live">Developers Live</a></li>
                                    <li><a href="/wiki/Doodle4Google" title="Doodle4Google">Doodle4Google</a></li>
                                    <li><a href="/wiki/Google_I/O" title="Google I/O">I/O</a></li>
                                    <li><a href="/wiki/Jigsaw_(company)" title="Jigsaw (company)">Jigsaw</a></li>
                                    <li><i><a href="/wiki/Living_Stories" title="Living Stories">Living Stories</a></i></li>
                                    <li><i><a href="/wiki/Google_Lunar_X_Prize" title="Google Lunar X Prize">Lunar XPRIZE</a></i></li>
                                    <li><i><a href="/wiki/Google_Mapathon" title="Google Mapathon">Mapathon</a></i></li>
                                    <li><a href="/wiki/Google_Science_Fair" title="Google Science Fair">Science Fair</a></li>
                                    <li><a href="/wiki/Google_Summer_of_Code" title="Google Summer of Code">Summer of Code</a></li>
                                    <li><a href="/wiki/Talks_at_Google" title="Talks at Google">Talks at Google</a></li>
                                    <li>
                                       YouTube
                                       <ul>
                                          <li><a href="/wiki/YouTube_Awards" title="YouTube Awards">Awards</a></li>
                                          <li><a href="/wiki/CNN/YouTube_presidential_debates" title="CNN/YouTube presidential debates">CNN/YouTube presidential debates</a></li>
                                          <li><a href="/wiki/YouTube_Comedy_Week" title="YouTube Comedy Week">Comedy Week</a></li>
                                          <li><a href="/wiki/YouTube_Live" title="YouTube Live">Live</a></li>
                                          <li><a href="/wiki/YouTube_Music_Awards" title="YouTube Music Awards">Music Awards</a></li>
                                          <li><a href="/wiki/YouTube_Space_Lab" title="YouTube Space Lab">Space Lab</a></li>
                                          <li><a href="/wiki/YouTube_Symphony_Orchestra" title="YouTube Symphony Orchestra">Symphony Orchestra</a></li>
                                       </ul>
                                    </li>
                                    <li>
                                       Initiatives and projects
                                       <ul>
                                          <li><a href="/wiki/A_Google_A_Day" title="A Google A Day">A Google A Day</a></li>
                                          <li>
                                             Area 120
                                             <ul>
                                                <li><a href="/wiki/Reply_(Google)" title="Reply (Google)">Reply</a></li>
                                                <li><a href="/wiki/Tables_(Google)" title="Tables (Google)">Tables</a></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/Google_ATAP" title="Google ATAP">ATAP</a></li>
                                          <li><a href="/wiki/Google_Arts_%26_Culture#Google_Cultural_Institute" title="Google Arts &amp; Culture">Cultural Institute</a></li>
                                          <li><a href="/wiki/Google_Data_Liberation_Front" title="Google Data Liberation Front">Data Liberation Front</a></li>
                                          <li><a href="/wiki/Data_Transfer_Project" title="Data Transfer Project">Data Transfer Project</a></li>
                                          <li><a href="/wiki/Digital_Unlocked" title="Digital Unlocked">Digital Unlocked</a></li>
                                          <li><i><a href="/wiki/Dragonfly_(search_engine)" title="Dragonfly (search engine)">Dragonfly</a></i></li>
                                          <li><a href="/wiki/Google_Get_Your_Business_Online" title="Google Get Your Business Online">Get Your Business Online</a></li>
                                          <li><a href="/wiki/Google_for_Education" title="Google for Education">Google for Education</a></li>
                                          <li><a href="/wiki/Google_for_Startups" title="Google for Startups">Google for Startups</a></li>
                                          <li><i><a href="/wiki/Google_Labs" title="Google Labs">Labs</a></i></li>
                                          <li><a href="/wiki/Liquid_Galaxy" title="Liquid Galaxy">Liquid Galaxy</a></li>
                                          <li><a href="/wiki/Made_with_Code" title="Made with Code">Made with Code</a></li>
                                          <li><a href="/wiki/Project_Nightingale" title="Project Nightingale">Nightingale</a></li>
                                          <li><a href="/wiki/RechargeIT" title="RechargeIT">RechargeIT</a></li>
                                          <li><a href="/wiki/Project_Shield" title="Project Shield">Shield</a></li>
                                          <li><a href="/wiki/Project_Sunroof" title="Project Sunroof">Sunroof</a></li>
                                          <li><a href="/wiki/Project_Zero" title="Project Zero">Zero</a></li>
                                       </ul>
                                    </li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Criticism_of_Google" title="Criticism of Google">Criticism</a></th>
                           <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li><a href="/wiki/2018_Google_walkouts" title="2018 Google walkouts">2018 walkouts</a></li>
                                    <li><a href="/wiki/2020_Google_services_outages" title="2020 Google services outages">2020 services outages</a></li>
                                    <li><a href="/wiki/Alphabet_Workers_Union" title="Alphabet Workers Union">Alphabet Workers Union</a></li>
                                    <li><a href="/wiki/Censorship_by_Google" title="Censorship by Google">Censorship</a></li>
                                    <li><a href="/wiki/DeGoogle" title="DeGoogle">DeGoogle</a></li>
                                    <li><i><a href="/wiki/Dragonfly_(search_engine)" title="Dragonfly (search engine)">Dragonfly</a></i></li>
                                    <li><a href="/wiki/FairSearch" title="FairSearch">FairSearch</a></li>
                                    <li><a href="/wiki/Google%27s_Ideological_Echo_Chamber" title="Google's Ideological Echo Chamber">"Ideological Echo Chamber" memo</a></li>
                                    <li><i><a href="/wiki/Is_Google_Making_Us_Stupid%3F" title="Is Google Making Us Stupid?">Is Google Making Us Stupid?</a></i></li>
                                    <li><a href="/wiki/Google_litigation" title="Google litigation">Litigation</a></li>
                                    <li><a href="/wiki/Predictions_of_the_end_of_Google" title="Predictions of the end of Google">Predictions of the end of Google</a></li>
                                    <li>
                                       <a href="/wiki/Privacy_concerns_regarding_Google" title="Privacy concerns regarding Google">Privacy concerns</a>
                                       <ul>
                                          <li><a href="/wiki/Google_Street_View_privacy_concerns" title="Google Street View privacy concerns">Street View</a></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/San_Francisco_tech_bus_protests" title="San Francisco tech bus protests">San Francisco tech bus protests</a></li>
                                    <li><a href="/wiki/Google_worker_organization" title="Google worker organization">Worker organization</a></li>
                                    <li>
                                       <a href="/wiki/Criticism_of_Google#YouTube" title="Criticism of Google">YouTube</a>
                                       <ul>
                                          <li><a href="/wiki/YouTuber_back_advertisement_controversy_in_Korea_in_2020" title="YouTuber back advertisement controversy in Korea in 2020">Back advertisement controversy</a></li>
                                          <li><a href="/wiki/Censorship_by_Google#YouTube" title="Censorship by Google">Censorship</a></li>
                                          <li><a href="/wiki/YouTube_copyright_issues" title="YouTube copyright issues">Copyright issues</a></li>
                                          <li><a href="/wiki/YouTube_copyright_strike" title="YouTube copyright strike">Copyright strike</a></li>
                                          <li><a href="/wiki/Elsagate" title="Elsagate">Elsagate</a></li>
                                          <li><a href="/wiki/Fantastic_Adventures_scandal" title="Fantastic Adventures scandal">Fantastic Adventures scandal</a></li>
                                          <li><a href="/wiki/YouTube_headquarters_shooting" title="YouTube headquarters shooting">Headquarters shooting</a></li>
                                          <li><a href="/wiki/2012_Kohistan_video_case" title="2012 Kohistan video case">Kohistan video case</a></li>
                                          <li><a href="/wiki/Reactions_to_Innocence_of_Muslims" title="Reactions to Innocence of Muslims">Reactions to <i>Innocence of Muslims</i></a></li>
                                          <li><a href="/wiki/2011_Slovenian_YouTube_incident" title="2011 Slovenian YouTube incident">Slovenian government incident</a></li>
                                       </ul>
                                    </li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                     </tbody>
                  </table>
                  <div></div>
               </td>
               <td class="noviewer navbox-image" rowspan="5" style="width:1px;padding:0px 0px 0px 2px">
                  <div><a href="/wiki/File:Google_2015_logo.svg" class="image"><img alt="Google 2015 logo.svg" src="//upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/80px-Google_2015_logo.svg.png" decoding="async" width="80" height="27" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/120px-Google_2015_logo.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/160px-Google_2015_logo.svg.png 2x" data-file-width="272" data-file-height="92"></a></div>
               </td>
            </tr>
            <tr style="display: none;">
               <th scope="row" class="navbox-group" style="width:1%">Development</th>
               <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                  <div style="padding:0em 0.25em"></div>
                  <table class="nowraplinks navbox-subgroup" style="border-spacing:0">
                     <tbody>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Operating systems</th>
                           <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li>
                                       <a href="/wiki/Android_(operating_system)" title="Android (operating system)">Android</a>
                                       <ul>
                                          <li><a href="/wiki/Android_Automotive" title="Android Automotive">Automotive</a></li>
                                          <li><a href="/wiki/Glass_OS" title="Glass OS">Glass OS</a></li>
                                          <li><a href="/wiki/Android_Go" title="Android Go">Go</a></li>
                                          <li><a href="/wiki/GLinux" title="GLinux">gLinux</a></li>
                                          <li><i><a href="/wiki/Goobuntu" title="Goobuntu">Goobuntu</a></i></li>
                                          <li><i><a href="/wiki/Android_Things" title="Android Things">Things</a></i></li>
                                          <li><a href="/wiki/Android_TV" title="Android TV">TV</a></li>
                                          <li><a href="/wiki/Wear_OS" title="Wear OS">Wear</a></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Chrome_OS" title="Chrome OS">Chrome OS</a></li>
                                    <li><a href="/wiki/Chromium_OS" title="Chromium OS">Chromium OS</a></li>
                                    <li><a href="/wiki/Google_Fuchsia" title="Google Fuchsia">Fuchsia</a></li>
                                    <li><i><a href="/wiki/Google_TV_(operating_system)" title="Google TV (operating system)">TV</a></i></li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Libraries/frameworks</th>
                           <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li><a href="/wiki/Accelerated_Mobile_Pages" title="Accelerated Mobile Pages">AMP</a></li>
                                    <li>
                                       Angular
                                       <ul>
                                          <li><a href="/wiki/Angular_(web_framework)" title="Angular (web framework)">Angular</a></li>
                                          <li><i><a href="/wiki/AngularJS" title="AngularJS">AngularJS</a></i></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/ARCore" title="ARCore">ARCore</a></li>
                                    <li><a href="/wiki/Google_APIs" title="Google APIs">APIs</a></li>
                                    <li><a href="/wiki/Google_Chart_API" title="Google Chart API">Chart API</a></li>
                                    <li><a href="/wiki/Google_Charts" title="Google Charts">Charts</a></li>
                                    <li><a href="/wiki/Dialogflow" title="Dialogflow">Dialogflow</a></li>
                                    <li><a href="/wiki/Google_Fast_Pair" title="Google Fast Pair">Fast Pair</a></li>
                                    <li><a href="/wiki/Google_File_System" title="Google File System">File System</a></li>
                                    <li><a href="/wiki/Federated_Learning_of_Cohorts" title="Federated Learning of Cohorts">Federated Learning of Cohorts</a></li>
                                    <li><a href="/wiki/Flutter_(software)" title="Flutter (software)">Flutter</a></li>
                                    <li><i><a href="/wiki/Gears_(software)" title="Gears (software)">Gears</a></i></li>
                                    <li><a href="/wiki/Google_Guava" title="Google Guava">Guava</a></li>
                                    <li><a href="/wiki/Google_Guice" title="Google Guice">Guice</a></li>
                                    <li><a href="/wiki/Google_mobile_services" title="Google mobile services">Mobile Services</a></li>
                                    <li><i><a href="/wiki/Google_Pack" title="Google Pack">Pack</a></i></li>
                                    <li>
                                       <a href="/wiki/Polymer_(library)" title="Polymer (library)">Polymer</a>
                                       <ul>
                                          <li><a href="/wiki/Google_Web_Components" title="Google Web Components">Web Components</a></li>
                                       </ul>
                                    </li>
                                    <li><i><a href="/wiki/Tango_(platform)" title="Tango (platform)">Tango</a></i></li>
                                    <li><a href="/wiki/TensorFlow" title="TensorFlow">TensorFlow</a></li>
                                    <li><i><a href="/wiki/Google_Web_Accelerator" title="Google Web Accelerator">Web Accelerator</a></i></li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Tools</th>
                           <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li><i><a href="/wiki/Android_Cloud_to_Device_Messaging" title="Android Cloud to Device Messaging">Android Cloud to Device Messaging</a></i></li>
                                    <li><a href="/wiki/Android_Studio" title="Android Studio">Android Studio</a></li>
                                    <li><a href="/wiki/App_Inventor_for_Android" title="App Inventor for Android">App Inventor</a></li>
                                    <li><i><a href="/wiki/Google_App_Maker" title="Google App Maker">App Maker</a></i></li>
                                    <li><a href="/wiki/AppSheet" title="AppSheet">AppSheet</a></li>
                                    <li><a href="/wiki/Google_Closure_Tools" title="Google Closure Tools">Closure Tools</a></li>
                                    <li><a href="/wiki/Google_Gadgets" title="Google Gadgets">Gadgets</a></li>
                                    <li><a href="/wiki/GData" title="GData">GData</a></li>
                                    <li><a href="/wiki/GYP_(software)" title="GYP (software)">GYP</a></li>
                                    <li><a href="/wiki/Google_Kythe" title="Google Kythe">Kythe</a></li>
                                    <li><a href="/wiki/Google_Lighthouse" title="Google Lighthouse">Lighthouse</a></li>
                                    <li><i><a href="/wiki/Google_Native_Client" title="Google Native Client">Native Client</a></i></li>
                                    <li><i><a href="/wiki/Browser_speed_test#Octane_(unmaintained)" title="Browser speed test">Octane</a></i></li>
                                    <li><a href="/wiki/Google_Optimize" title="Google Optimize">Optimize</a></li>
                                    <li><a href="/wiki/OpenRefine" title="OpenRefine">OpenRefine</a></li>
                                    <li><a href="/wiki/Google_PageSpeed_Tools" title="Google PageSpeed Tools">PageSpeed</a></li>
                                    <li><a href="/wiki/ReCAPTCHA" title="ReCAPTCHA">reCAPTCHA</a></li>
                                    <li><a href="/wiki/Google_Search_Console" title="Google Search Console">Search Console</a></li>
                                    <li><a href="/wiki/Sitemaps" title="Sitemaps">Sitemaps</a></li>
                                    <li><i><a href="/wiki/Google_Swiffy" title="Google Swiffy">Swiffy</a></i></li>
                                    <li><a href="/wiki/Google_Web_Toolkit" title="Google Web Toolkit">Web Toolkit</a></li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Search algorithms</th>
                           <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li><a href="/wiki/Google_Hummingbird" title="Google Hummingbird">Hummingbird</a></li>
                                    <li><a href="/wiki/PageRank" title="PageRank">PageRank</a></li>
                                    <li><a href="/wiki/Google_Panda" title="Google Panda">Panda</a></li>
                                    <li><a href="/wiki/Google_Penguin" title="Google Penguin">Penguin</a></li>
                                    <li><a href="/wiki/Google_Pigeon" title="Google Pigeon">Pigeon</a></li>
                                    <li><a href="/wiki/RankBrain" title="RankBrain">RankBrain</a></li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Others</th>
                           <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li><a href="/wiki/Google_Chrome_Experiments" title="Google Chrome Experiments">Chrome Experiments</a></li>
                                    <li><a href="/wiki/Google_Developers" title="Google Developers">Developers</a></li>
                                    <li>
                                       Media file formats
                                       <ul>
                                          <li>
                                             <a href="/wiki/WebM" title="WebM">WebM</a>
                                             <ul>
                                                <li><a href="/wiki/VP8" title="VP8">VP8</a></li>
                                                <li><a href="/wiki/VP9" title="VP9">VP9</a></li>
                                                <li><a href="/wiki/AV1" title="AV1">AV1</a></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/WebP" title="WebP">WebP</a></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/OpenSocial" title="OpenSocial">OpenSocial</a></li>
                                    <li>
                                       Platforms
                                       <ul>
                                          <li><a href="/wiki/Google_App_Engine" title="Google App Engine">App Engine</a></li>
                                          <li><a href="/wiki/Google_Apps_Script" title="Google Apps Script">Apps Script</a></li>
                                          <li>
                                             <a href="/wiki/Google_Cloud_Platform" title="Google Cloud Platform">Cloud Platform</a>
                                             <ul>
                                                <li><i><a href="/wiki/Google_Cloud_Connect" title="Google Cloud Connect">Connect</a></i></li>
                                                <li><a href="/wiki/Google_Cloud_Dataflow" title="Google Cloud Dataflow">Dataflow</a></li>
                                                <li><a href="/wiki/Google_Cloud_Datastore" title="Google Cloud Datastore">Datastore</a></li>
                                                <li><i><a href="/wiki/Google_Cloud_Messaging" title="Google Cloud Messaging">Messaging</a></i></li>
                                                <li><i><a href="/wiki/Stackdriver" title="Stackdriver">Stackdriver</a></i></li>
                                                <li><a href="/wiki/Google_Cloud_Storage" title="Google Cloud Storage">Storage</a></li>
                                             </ul>
                                          </li>
                                          <li>
                                             <a href="/wiki/Firebase" title="Firebase">Firebase</a>
                                             <ul>
                                                <li><a href="/wiki/Firebase_Cloud_Messaging" title="Firebase Cloud Messaging">Cloud Messaging</a></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/Gerrit_(software)" title="Gerrit (software)">Gerrit</a></li>
                                          <li><a href="/wiki/Kubernetes" title="Kubernetes">Kubernetes</a></li>
                                       </ul>
                                    </li>
                                    <li>
                                       Programming languages
                                       <ul>
                                          <li><a href="/wiki/Dart_(programming_language)" title="Dart (programming language)">Dart</a></li>
                                          <li><a href="/wiki/Go_(programming_language)" title="Go (programming language)">Go</a></li>
                                          <li><i><a href="/wiki/Sawzall_(programming_language)" title="Sawzall (programming language)">Sawzall</a></i></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_Web_Server" title="Google Web Server">Web Server</a></li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                     </tbody>
                  </table>
                  <div></div>
               </td>
            </tr>
            <tr style="display: none;">
               <th scope="row" class="navbox-group" style="width:1%">Services</th>
               <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                  <div style="padding:0em 0.25em"></div>
                  <table class="nowraplinks navbox-subgroup" style="border-spacing:0">
                     <tbody>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Entertainment</th>
                           <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li><a href="/wiki/Chromecast" title="Chromecast">Chromecast</a></li>
                                    <li><i><a href="/wiki/Google_Currents_(2011%E2%80%932013)" title="Google Currents (2011–2013)">Currents</a></i></li>
                                    <li>
                                       <a href="/wiki/Google_Play" title="Google Play">Play</a>
                                       <ul>
                                          <li><a href="/wiki/Google_Play_Books" title="Google Play Books">Books</a></li>
                                          <li><a href="/wiki/Google_Play_Games" title="Google Play Games">Games</a></li>
                                          <li><i><a href="/wiki/Google_Play_Music" title="Google Play Music">Music</a></i></li>
                                          <li><i><a href="/wiki/Google_Play_Newsstand" title="Google Play Newsstand">Newsstand</a></i></li>
                                          <li><a href="/wiki/Google_Play_Pass" title="Google Play Pass">Pass</a></li>
                                          <li><a href="/wiki/Google_Play_Services" title="Google Play Services">Services</a></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_Podcasts" title="Google Podcasts">Podcasts</a></li>
                                    <li><a href="/wiki/Google_Public_DNS" title="Google Public DNS">Public DNS</a></li>
                                    <li><a href="/wiki/Quick,_Draw!" title="Quick, Draw!">Quick, Draw!</a></li>
                                    <li><a href="/wiki/Google_Santa_Tracker" title="Google Santa Tracker">Santa Tracker</a></li>
                                    <li>
                                       <a href="/wiki/Google_Stadia" title="Google Stadia">Stadia</a>
                                       <ul>
                                          <li><a href="/wiki/List_of_Stadia_games" title="List of Stadia games">Games</a></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_TV" title="Google TV">TV</a></li>
                                    <li><a href="/wiki/Vevo" title="Vevo">Vevo</a></li>
                                    <li><i><a href="/wiki/Google_Video" title="Google Video">Video</a></i></li>
                                    <li>
                                       <a href="/wiki/YouTube" title="YouTube">YouTube</a>
                                       <ul>
                                          <li><a href="/wiki/YouTube_API" title="YouTube API">API</a></li>
                                          <li><a href="/wiki/Content_ID_(system)" title="Content ID (system)">Content ID</a></li>
                                          <li><i><a href="/wiki/FameBit" title="FameBit">FameBit</a></i></li>
                                          <li><a href="/wiki/YouTube_Instant" title="YouTube Instant">Instant</a></li>
                                          <li><a href="/wiki/YouTube_Kids" title="YouTube Kids">Kids</a></li>
                                          <li><a href="/wiki/YouTube_Music" title="YouTube Music">Music</a></li>
                                          <li><a href="/wiki/YouTube_(channel)" title="YouTube (channel)">Official channel</a></li>
                                          <li><a href="/wiki/Google_Preferred" title="Google Preferred">Preferred</a></li>
                                          <li>
                                             <a href="/wiki/YouTube_Premium" title="YouTube Premium">Premium</a>
                                             <ul>
                                                <li><a href="/wiki/List_of_YouTube_Premium_original_programming" title="List of YouTube Premium original programming">original programming</a></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/YouTube_TV" title="YouTube TV">TV</a></li>
                                       </ul>
                                    </li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Communication</th>
                           <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li><i><a href="/wiki/Google_Allo" title="Google Allo">Allo</a></i></li>
                                    <li><i><a href="/wiki/Google_Buzz" title="Google Buzz">Buzz</a></i></li>
                                    <li><a href="/wiki/Google_Chat" title="Google Chat">Chat</a></li>
                                    <li><a href="/wiki/Google_Contacts" title="Google Contacts">Contacts</a></li>
                                    <li><a href="/wiki/Google_Currents" title="Google Currents">Currents</a></li>
                                    <li><i><a href="/wiki/Dodgeball_(service)" title="Dodgeball (service)">Dodgeball</a></i></li>
                                    <li><a href="/wiki/Google_Duo" title="Google Duo">Duo</a></li>
                                    <li><a href="/wiki/Google_Fi" title="Google Fi">Fi</a></li>
                                    <li><i><a href="/wiki/Google_Friend_Connect" title="Google Friend Connect">Friend Connect</a></i></li>
                                    <li><i><a href="/wiki/Gizmo5" title="Gizmo5">Gizmo5</a></i></li>
                                    <li><i><a href="/wiki/Google%2B" title="Google+">Google+</a></i></li>
                                    <li>
                                       <a href="/wiki/Gmail" title="Gmail">Gmail</a>
                                       <ul>
                                          <li><i><a href="/wiki/Inbox_by_Gmail" title="Inbox by Gmail">Inbox</a></i></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_Groups" title="Google Groups">Groups</a></li>
                                    <li><a href="/wiki/Google_Hangouts" title="Google Hangouts">Hangouts</a></li>
                                    <li><i><a href="/wiki/Google_Helpouts" title="Google Helpouts">Helpouts</a></i></li>
                                    <li>
                                       <a href="/wiki/Google_IME" title="Google IME">IME</a>
                                       <ul>
                                          <li><a href="/wiki/Google_Japanese_Input" title="Google Japanese Input">Japanese</a></li>
                                          <li><a href="/wiki/Google_Pinyin" title="Google Pinyin">Pinyin</a></li>
                                          <li><a href="/wiki/Google_transliteration" title="Google transliteration">Transliteration</a></li>
                                       </ul>
                                    </li>
                                    <li><i><a href="/wiki/Jaiku" title="Jaiku">Jaiku</a></i></li>
                                    <li><i><a href="/wiki/Meebo" title="Meebo">Meebo</a></i></li>
                                    <li><a href="/wiki/Google_Meet" title="Google Meet">Meet</a></li>
                                    <li><a href="/wiki/Messages_(Google)" title="Messages (Google)">Messages</a></li>
                                    <li><i><a href="/wiki/Google_Moderator" title="Google Moderator">Moderator</a></i></li>
                                    <li><i><a href="/wiki/Orkut" title="Orkut">Orkut</a></i></li>
                                    <li><i><a href="/wiki/Google_Schemer" title="Google Schemer">Schemer</a></i></li>
                                    <li><i><a href="/wiki/Google_Spaces" title="Google Spaces">Spaces</a></i></li>
                                    <li><i><a href="/wiki/Google_Talk" title="Google Talk">Talk</a></i></li>
                                    <li>
                                       <a href="/wiki/Google_Translate" title="Google Translate">Translate</a>
                                       <ul>
                                          <li><i><a href="/wiki/Google_Translator_Toolkit" title="Google Translator Toolkit">Translator Toolkit</a></i></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_Voice" title="Google Voice">Voice</a></li>
                                    <li><i><a href="/wiki/Apache_Wave" title="Apache Wave">Wave</a></i></li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Google_Search" title="Google Search">Search</a></th>
                           <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li><i><a href="/wiki/Aardvark_(search_engine)" title="Aardvark (search engine)">Aardvark</a></i></li>
                                    <li><a href="/wiki/Google_Alerts" title="Google Alerts">Alerts</a></li>
                                    <li><i><a href="/wiki/Google_Answers" title="Google Answers">Answers</a></i></li>
                                    <li><i><a href="/wiki/Google_Base" title="Google Base">Base</a></i></li>
                                    <li><i><a href="/wiki/Google_Blog_Search" title="Google Blog Search">Blog Search</a></i></li>
                                    <li>
                                       <a href="/wiki/Google_Books" title="Google Books">Books</a>
                                       <ul>
                                          <li><a href="/wiki/Google_Ngram_Viewer" title="Google Ngram Viewer">Ngram Viewer</a></li>
                                       </ul>
                                    </li>
                                    <li><i><a href="/wiki/Google_Code_Search" title="Google Code Search">Code Search</a></i></li>
                                    <li><a href="/wiki/Google_Dataset_Search" title="Google Dataset Search">Dataset Search</a></li>
                                    <li><a href="/wiki/Google_Dictionary" title="Google Dictionary">Dictionary</a></li>
                                    <li><i><a href="/wiki/Google_Directory" title="Google Directory">Directory</a></i></li>
                                    <li><i><a href="/wiki/Google_Fast_Flip" title="Google Fast Flip">Fast Flip</a></i></li>
                                    <li><a href="/wiki/Google_Flights" title="Google Flights">Flights</a></li>
                                    <li><i><a href="/wiki/Google_Flu_Trends" title="Google Flu Trends">Flu Trends</a></i></li>
                                    <li><a href="/wiki/Google_Finance" title="Google Finance">Finance</a></li>
                                    <li><i><a href="/wiki/Google_Goggles" title="Google Goggles">Goggles</a></i></li>
                                    <li><i><a href="/wiki/GOOG-411" title="GOOG-411">GOOG-411</a></i></li>
                                    <li><a href="/wiki/Googlebot" title="Googlebot">Googlebot</a></li>
                                    <li>
                                       <a href="/wiki/Google_Images" title="Google Images">Images</a>
                                       <ul>
                                          <li><i><a href="/wiki/Google_Image_Labeler" title="Google Image Labeler">Image Labeler</a></i></li>
                                          <li><i><a href="/wiki/Google_Image_Swirl" title="Google Image Swirl">Image Swirl</a></i></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_Knowledge_Graph" title="Google Knowledge Graph">Knowledge Graph</a></li>
                                    <li>
                                       <a href="/wiki/Google_News" title="Google News">News</a>
                                       <ul>
                                          <li><i><a href="/wiki/Google_News_%26_Weather" title="Google News &amp; Weather">Weather</a></i></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_Patents" title="Google Patents">Patents</a></li>
                                    <li><i><a href="/wiki/Google_Personalized_Search" title="Google Personalized Search">Personalized Search</a></i></li>
                                    <li><a href="/wiki/Google_Public_Data_Explorer" title="Google Public Data Explorer">Public Data Explorer</a></li>
                                    <li><i><a href="/wiki/Google_Questions_and_Answers" title="Google Questions and Answers">Questions and Answers</a></i></li>
                                    <li><a href="/wiki/SafeSearch" title="SafeSearch">SafeSearch</a></li>
                                    <li><a href="/wiki/Google_Scholar" title="Google Scholar">Scholar</a></li>
                                    <li><i><a href="/wiki/Google_SearchWiki" title="Google SearchWiki">Searchwiki</a></i></li>
                                    <li>
                                       <a href="/wiki/Google_Shopping" title="Google Shopping">Shopping</a>
                                       <ul>
                                          <li><i><a href="/wiki/Google_Express" title="Google Express">Express</a></i></li>
                                       </ul>
                                    </li>
                                    <li><i><a href="/wiki/Google_Squared" title="Google Squared">Squared</a></i></li>
                                    <li><a href="/wiki/Tenor_(website)" title="Tenor (website)">Tenor</a></li>
                                    <li>
                                       <a href="/wiki/Google_Trends" title="Google Trends">Trends</a>
                                       <ul>
                                          <li><i><a href="/wiki/Google_Insights_for_Search" title="Google Insights for Search">Insights for Search</a></i></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_Videos" class="mw-redirect" title="Google Videos">Videos</a></li>
                                    <li><a href="/wiki/Google_Voice_Search" title="Google Voice Search">Voice Search</a></li>
                                    <li><i><a href="/wiki/WDYL_(search_engine)" title="WDYL (search engine)">WDYL</a></i></li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Navigation</th>
                           <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li>
                                       <a href="/wiki/Google_Earth" title="Google Earth">Earth</a>
                                       <ul>
                                          <li><a href="/wiki/Google_Earth#Google_Mars" title="Google Earth">Mars</a></li>
                                          <li><a href="/wiki/Google_Earth#Google_Moon" title="Google Earth">Moon</a></li>
                                          <li><a href="/wiki/Google_Earth#Google_Sky" title="Google Earth">Sky</a></li>
                                       </ul>
                                    </li>
                                    <li>
                                       <a href="/wiki/Google_Maps" title="Google Maps">Maps</a>
                                       <ul>
                                          <li><i><a href="/wiki/Google_Latitude" title="Google Latitude">Latitude</a></i></li>
                                          <li><i><a href="/wiki/Google_Map_Maker" title="Google Map Maker">Map Maker</a></i></li>
                                          <li><i><a href="/wiki/Google_Maps_Navigation" title="Google Maps Navigation">Navigation</a></i></li>
                                          <li><a href="/wiki/Google_Maps#Google_My_Maps" title="Google Maps">My Maps</a></li>
                                          <li><a href="/wiki/Google_Maps_pin" title="Google Maps pin">Pin</a></li>
                                          <li><a href="/wiki/Pointy" title="Pointy">Pointy</a></li>
                                          <li>
                                             <a href="/wiki/Google_Street_View" title="Google Street View">Street View</a>
                                             <ul>
                                                <li><a href="/wiki/Coverage_of_Google_Street_View" title="Coverage of Google Street View">Coverage</a></li>
                                                <li><a href="/wiki/Street_View_Trusted" title="Street View Trusted">Trusted</a></li>
                                             </ul>
                                          </li>
                                       </ul>
                                    </li>
                                    <li><i><a href="/wiki/Google_Trips" title="Google Trips">Trips</a></i></li>
                                    <li><a href="/wiki/Waze" title="Waze">Waze</a></li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Organization</th>
                           <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li><a href="/wiki/Google_Bookmarks" title="Google Bookmarks">Bookmarks</a></li>
                                    <li><a href="/wiki/Google_Calendar" title="Google Calendar">Calendar</a></li>
                                    <li><a href="/wiki/Google_Cloud_Search" title="Google Cloud Search">Cloud Search</a></li>
                                    <li><i><a href="/wiki/Google_Desktop" title="Google Desktop">Desktop</a></i></li>
                                    <li>
                                       <a href="/wiki/Google_Drive" title="Google Drive">Drive</a>
                                       <ul>
                                          <li>
                                             <a href="/wiki/Google_Docs_Editors" title="Google Docs Editors">Docs Editors</a>
                                             <ul>
                                                <li><a href="/wiki/Google_Docs" title="Google Docs">Docs</a></li>
                                                <li><a href="/wiki/Google_Drawings" title="Google Drawings">Drawings</a></li>
                                                <li><a href="/wiki/Google_Forms" title="Google Forms">Forms</a></li>
                                                <li><i><a href="/wiki/Google_Fusion_Tables" title="Google Fusion Tables">Fusion Tables</a></i></li>
                                                <li><a href="/wiki/Google_Keep" title="Google Keep">Keep</a></li>
                                                <li><a href="/wiki/Google_Sheets" title="Google Sheets">Sheets</a></li>
                                                <li><a href="/wiki/Google_Slides" title="Google Slides">Slides</a></li>
                                                <li><a href="/wiki/Google_Sites" title="Google Sites">Sites</a></li>
                                             </ul>
                                          </li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Files_(Google)" title="Files (Google)">Files</a></li>
                                    <li><i><a href="/wiki/IGoogle" title="IGoogle">iGoogle</a></i></li>
                                    <li><a href="/wiki/Jamboard" title="Jamboard">Jamboard</a></li>
                                    <li><i><a href="/wiki/Google_Notebook" title="Google Notebook">Notebook</a></i></li>
                                    <li><a href="/wiki/Google_One" title="Google One">One</a></li>
                                    <li><a href="/wiki/Google_Photos" title="Google Photos">Photos</a></li>
                                    <li><i><a href="/wiki/Quickoffice" title="Quickoffice">Quickoffice</a></i></li>
                                    <li><a href="/wiki/Google_Surveys" title="Google Surveys">Surveys</a></li>
                                    <li><i><a href="/wiki/Google_Sync" title="Google Sync">Sync</a></i></li>
                                    <li><a href="/wiki/Google_Calendar" title="Google Calendar">Tasks</a></li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Others</th>
                           <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li>
                                       <a href="/wiki/Google_Account" title="Google Account">Account</a>
                                       <ul>
                                          <li><a href="/wiki/Google_Dashboard" title="Google Dashboard">Dashboard</a></li>
                                          <li><a href="/wiki/Google_Takeout" title="Google Takeout">Takeout</a></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Android_Auto" title="Android Auto">Android Auto</a></li>
                                    <li><a href="/wiki/Google_Arts_%26_Culture" title="Google Arts &amp; Culture">Arts &amp; Culture</a></li>
                                    <li><a href="/wiki/Google_Assistant" title="Google Assistant">Assistant</a></li>
                                    <li><a href="/wiki/Google_Authenticator" title="Google Authenticator">Authenticator</a></li>
                                    <li><i><a href="/wiki/ZygoteBody" title="ZygoteBody">Body</a></i> (now <a href="/wiki/ZygoteBody" title="ZygoteBody">ZygoteBody</a>)</li>
                                    <li><i><a href="/wiki/Google_Building_Maker" title="Google Building Maker">Building Maker</a></i></li>
                                    <li>
                                       Business and finance
                                       <ul>
                                          <li><a href="/wiki/Google_Ads#Google_Ad_Grants" title="Google Ads">Ad Grants</a></li>
                                          <li><a href="/wiki/Google_Ad_Manager" title="Google Ad Manager">Ad Manager</a></li>
                                          <li><a href="/wiki/AdMob" title="AdMob">AdMob</a></li>
                                          <li><a href="/wiki/Google_Ads" title="Google Ads">Ads</a></li>
                                          <li><a href="/wiki/Adscape" title="Adscape">Adscape</a></li>
                                          <li><a href="/wiki/Google_AdSense" title="Google AdSense">AdSense</a></li>
                                          <li><a href="/wiki/Google_Attribution" title="Google Attribution">Attribution</a></li>
                                          <li><i><a href="/wiki/BebaPay" title="BebaPay">BebaPay</a></i></li>
                                          <li><a href="/wiki/Google_Business_Groups" title="Google Business Groups">Business Groups</a></li>
                                          <li><i><a href="/wiki/Google_Checkout" title="Google Checkout">Checkout</a></i></li>
                                          <li><i><a href="/wiki/Google_Contributor" title="Google Contributor">Contributor</a></i></li>
                                          <li><i><a href="/wiki/DoubleClick" title="DoubleClick">DoubleClick</a></i></li>
                                          <li>
                                             <a href="/wiki/Google_Analytics" title="Google Analytics">Marketing Platform</a>
                                             <ul>
                                                <li><a href="/wiki/Google_Analytics" title="Google Analytics">Analytics</a></li>
                                                <li><i><a href="/wiki/Urchin_(software)" title="Urchin (software)">Urchin</a></i></li>
                                             </ul>
                                          </li>
                                          <li>
                                             <a href="/wiki/Google_Pay" title="Google Pay">Pay</a>
                                             <ul>
                                                <li><i><a href="/wiki/Google_Pay_Send" title="Google Pay Send">Pay Send</a></i></li>
                                                <li><i><a href="/wiki/Tez_(software)" title="Tez (software)">Tez</a></i></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/Google_Primer" title="Google Primer">Primer</a></li>
                                          <li><a href="/wiki/List_of_Google_products#Advertising_services" title="List of Google products">Tag Manager</a></li>
                                       </ul>
                                    </li>
                                    <li>
                                       <a href="/wiki/Google_Cast" title="Google Cast">Cast</a>
                                       <ul>
                                          <li><a href="/wiki/List_of_apps_with_Google_Cast_support" title="List of apps with Google Cast support">List of supported apps</a></li>
                                       </ul>
                                    </li>
                                    <li>
                                       <a href="/wiki/Google_Chrome" title="Google Chrome">Chrome</a>
                                       <ul>
                                          <li><a href="/wiki/Chromium_(web_browser)" title="Chromium (web browser)">Chromium</a></li>
                                          <li><a href="/wiki/Chrome_Remote_Desktop" title="Chrome Remote Desktop">Remote Desktop</a></li>
                                          <li><a href="/wiki/Google_Chrome_version_history" title="Google Chrome version history">Version History</a></li>
                                          <li><a href="/wiki/Chrome_Web_Store" title="Chrome Web Store">Web Store</a></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_Classroom" title="Google Classroom">Classroom</a></li>
                                    <li><i><a href="/wiki/Google_Cloud_Print" title="Google Cloud Print">Cloud Print</a></i></li>
                                    <li><a href="/wiki/Crowdsource_(app)" title="Crowdsource (app)">Crowdsource</a></li>
                                    <li><i><a href="/wiki/Google_Expeditions" title="Google Expeditions">Expeditions</a></i></li>
                                    <li><a href="/wiki/Find_My_Device" title="Find My Device">Find My Device</a></li>
                                    <li><a href="/wiki/Google_Fit" title="Google Fit">Fit</a></li>
                                    <li><a href="/wiki/Google_Fonts" title="Google Fonts">Google Fonts</a></li>
                                    <li><a href="/wiki/Gboard" title="Gboard">Gboard</a></li>
                                    <li><i><a href="/wiki/Google_Gesture_Search" title="Google Gesture Search">Gesture Search</a></i></li>
                                    <li>
                                       Images/photos
                                       <ul>
                                          <li><a href="/wiki/Google_Camera" title="Google Camera">Camera</a></li>
                                          <li><a href="/wiki/Google_Lens" title="Google Lens">Lens</a></li>
                                          <li><a href="/wiki/Snapseed" title="Snapseed">Snapseed</a></li>
                                          <li><i><a href="/wiki/Panoramio" title="Panoramio">Panoramio</a></i></li>
                                          <li><a href="/wiki/Google_Photos" title="Google Photos">Photos</a></li>
                                          <li>
                                             <i><a href="/wiki/Picasa" title="Picasa">Picasa</a></i>
                                             <ul>
                                                <li><i><a href="/wiki/Picasa_Web_Albums" title="Picasa Web Albums">Web Albums</a></i></li>
                                             </ul>
                                          </li>
                                          <li><i><a href="/wiki/Picnik" title="Picnik">Picnik</a></i></li>
                                       </ul>
                                    </li>
                                    <li><i><a href="/wiki/Knol" title="Knol">Knol</a></i></li>
                                    <li><i><a href="/wiki/Google_Lively" title="Google Lively">Lively</a></i></li>
                                    <li><a href="/wiki/Live_Transcribe" title="Live Transcribe">Live Transcribe</a></li>
                                    <li><i><a href="/wiki/Google_Mashup_Editor" title="Google Mashup Editor">Mashup Editor</a></i></li>
                                    <li><i><a href="/wiki/MyTracks" title="MyTracks">MyTracks</a></i></li>
                                    <li><a href="/wiki/Google_Now" title="Google Now">Now</a></li>
                                    <li><i><a href="/wiki/Google_Offers" title="Google Offers">Offers</a></i></li>
                                    <li><a href="/wiki/Google_Opinion_Rewards" title="Google Opinion Rewards">Opinion Rewards</a></li>
                                    <li><a href="/wiki/Google_Person_Finder" title="Google Person Finder">Person Finder</a></li>
                                    <li><i><a href="/wiki/Poly_(website)" title="Poly (website)">Poly</a></i></li>
                                    <li>
                                       Publishing
                                       <ul>
                                          <li><a href="/wiki/Blogger_(service)" title="Blogger (service)">Blogger</a></li>
                                          <li><a href="/wiki/Google_Domains" title="Google Domains">Domains</a></li>
                                          <li><a href="/wiki/FeedBurner" title="FeedBurner">FeedBurner</a></li>
                                          <li><i><a href="/wiki/Google_One_Pass" title="Google One Pass">One Pass</a></i></li>
                                          <li><i><a href="/wiki/Google_Page_Creator" title="Google Page Creator">Page Creator</a></i></li>
                                          <li><a href="/wiki/Google_Sites" title="Google Sites">Sites</a></li>
                                          <li><a href="/wiki/Google_Web_Designer" title="Google Web Designer">Web Designer</a></li>
                                       </ul>
                                    </li>
                                    <li><a href="/wiki/Google_Question_Hub" title="Google Question Hub">Question Hub</a></li>
                                    <li><a href="/wiki/Read_Along" title="Read Along">Read Along</a></li>
                                    <li><i><a href="/wiki/Google_Reader" title="Google Reader">Reader</a></i></li>
                                    <li><a href="/wiki/Google_Safe_Browsing" title="Google Safe Browsing">Safe Browsing</a></li>
                                    <li><i><a href="/wiki/Google_Sidewiki" title="Google Sidewiki">Sidewiki</a></i></li>
                                    <li><a href="/wiki/Socratic_(Google)" title="Socratic (Google)">Socratic</a></li>
                                    <li><i><a href="/wiki/Google_Station" title="Google Station">Station</a></i></li>
                                    <li><a href="/wiki/Google_Store" title="Google Store">Store</a></li>
                                    <li><i><a href="/wiki/Google_Swiffy" title="Google Swiffy">Swiffy</a></i></li>
                                    <li><a href="/wiki/Google_TalkBack" title="Google TalkBack">TalkBack</a></li>
                                    <li><a href="/wiki/Google_Text-to-Speech" title="Google Text-to-Speech">Text-to-Speech</a></li>
                                    <li><i><a href="/wiki/Google_URL_Shortener" title="Google URL Shortener">URL Shortener</a></i></li>
                                    <li><a href="/wiki/Google_Web_Light" title="Google Web Light">Web Light</a></li>
                                    <li><i><a href="/wiki/Google_WiFi" title="Google WiFi">WiFi</a></i></li>
                                    <li>
                                       <a href="/wiki/Google_Workspace" title="Google Workspace">Workspace</a>
                                       <ul>
                                          <li><a href="/wiki/Google_Workspace_Marketplace" title="Google Workspace Marketplace">Marketplace</a></li>
                                       </ul>
                                    </li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                     </tbody>
                  </table>
                  <div></div>
               </td>
            </tr>
            <tr style="display: none;">
               <th scope="row" class="navbox-group" style="width:1%">Hardware</th>
               <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                  <div style="padding:0em 0.25em">
                     <ul>
                        <li><a href="/wiki/Chromebit" title="Chromebit">Chromebit</a></li>
                        <li><a href="/wiki/Chromebox" title="Chromebox">Chromebox</a></li>
                        <li><i><a href="/wiki/Google_Clips" title="Google Clips">Clips</a></i></li>
                        <li>
                           Digital media players
                           <ul>
                              <li><a href="/wiki/Chromecast" title="Chromecast">Chromecast</a></li>
                              <li><i><a href="/wiki/Nexus_Player" title="Nexus Player">Nexus Player</a></i></li>
                              <li><i><a href="/wiki/Nexus_Q" title="Nexus Q">Nexus Q</a></i></li>
                           </ul>
                        </li>
                        <li><a href="/wiki/Fitbit" title="Fitbit">Fitbit</a></li>
                        <li>
                           Laptops and tablets
                           <ul>
                              <li><a href="/wiki/Chromebook" title="Chromebook">Chromebook</a></li>
                              <li>
                                 <i><a href="/wiki/Google_Nexus" title="Google Nexus">Nexus</a></i>
                                 <ul>
                                    <li><a href="/wiki/Nexus_7_(2012)" title="Nexus 7 (2012)">7 (2012)</a></li>
                                    <li><a href="/wiki/Nexus_7_(2013)" title="Nexus 7 (2013)">7 (2013)</a></li>
                                    <li><a href="/wiki/Nexus_10" title="Nexus 10">10</a></li>
                                    <li><a href="/wiki/Nexus_9" title="Nexus 9">9</a></li>
                                    <li><a href="/wiki/Comparison_of_Google_Nexus_tablets" title="Comparison of Google Nexus tablets">Comparison</a></li>
                                 </ul>
                              </li>
                              <li>
                                 <a href="/wiki/Google_Pixel" title="Google Pixel">Pixel</a>
                                 <ul>
                                    <li><a href="/wiki/Chromebook_Pixel" title="Chromebook Pixel">Chromebook Pixel</a></li>
                                    <li><a href="/wiki/Google_Pixelbook" title="Google Pixelbook">Pixelbook</a></li>
                                    <li><a href="/wiki/Google_Pixelbook_Go" title="Google Pixelbook Go">Pixelbook Go</a></li>
                                    <li><a href="/wiki/Pixel_C" title="Pixel C">C</a></li>
                                    <li><a href="/wiki/Pixel_Slate" title="Pixel Slate">Pixel Slate</a></li>
                                 </ul>
                              </li>
                           </ul>
                        </li>
                        <li>
                           <a href="/wiki/Google_Nest" title="Google Nest">Nest</a>
                           <ul>
                              <li><a href="/wiki/Google_Nest#Nest_Cam_Indoor" title="Google Nest">Cam</a></li>
                              <li><a href="/wiki/Google_Nest#Nest_Hello" title="Google Nest">Hello</a></li>
                              <li><a href="/wiki/Google_Nest#Nest_Protect" title="Google Nest">Protect</a></li>
                              <li><i><a href="/wiki/Google_Nest#Nest_Secure" title="Google Nest">Secure</a></i></li>
                              <li><a href="/wiki/Google_Nest_(smart_speakers)" title="Google Nest (smart speakers)">Smart Speakers</a></li>
                              <li><a href="/wiki/Nest_Thermostat" title="Nest Thermostat">Thermostat</a></li>
                              <li><a href="/wiki/Google_Nest_Wifi" title="Google Nest Wifi">Wifi</a></li>
                           </ul>
                        </li>
                        <li><a href="/wiki/Google_OnHub" title="Google OnHub">OnHub</a></li>
                        <li><a href="/wiki/Pixel_Buds" title="Pixel Buds">Pixel Buds</a></li>
                        <li><a href="/wiki/Google_Pixel#Pixel_Stand" title="Google Pixel">Pixel Stand</a></li>
                        <li><i><a href="/wiki/Pixel_Visual_Core" title="Pixel Visual Core">Pixel Visual Core</a></i></li>
                        <li><i><a href="/wiki/Google_Search_Appliance" title="Google Search Appliance">Search Appliance</a></i></li>
                        <li>
                           Smartphones
                           <ul>
                              <li>
                                 <a href="/wiki/Android_One" title="Android One">Android One</a>
                                 <ul>
                                    <li>
                                       <i><a href="/wiki/Google_Nexus" title="Google Nexus">Nexus</a></i>
                                       <ul>
                                          <li><a href="/wiki/Nexus_One" title="Nexus One">Nexus One</a></li>
                                          <li><a href="/wiki/Nexus_S" title="Nexus S">S</a></li>
                                          <li><a href="/wiki/Galaxy_Nexus" title="Galaxy Nexus">Galaxy Nexus</a></li>
                                          <li><a href="/wiki/Nexus_4" title="Nexus 4">4</a></li>
                                          <li><a href="/wiki/Nexus_5" title="Nexus 5">5</a></li>
                                          <li><a href="/wiki/Nexus_6" title="Nexus 6">6</a></li>
                                          <li><a href="/wiki/Nexus_5X" title="Nexus 5X">5X</a></li>
                                          <li><a href="/wiki/Nexus_6P" title="Nexus 6P">6P</a></li>
                                          <li><a href="/wiki/Comparison_of_Google_Nexus_smartphones" title="Comparison of Google Nexus smartphones">Comparison</a></li>
                                       </ul>
                                    </li>
                                    <li>
                                       <a href="/wiki/Google_Pixel" title="Google Pixel">Pixel</a>
                                       <ul>
                                          <li><a href="/wiki/Pixel_(1st_generation)" title="Pixel (1st generation)">Pixel</a></li>
                                          <li><a href="/wiki/Pixel_2" title="Pixel 2">2</a></li>
                                          <li><a href="/wiki/Pixel_3" title="Pixel 3">3</a></li>
                                          <li><a href="/wiki/Pixel_3a" title="Pixel 3a">3a</a></li>
                                          <li><a href="/wiki/Pixel_4" title="Pixel 4">4</a></li>
                                          <li><a href="/wiki/Pixel_4a" title="Pixel 4a">4a</a></li>
                                          <li><a href="/wiki/Pixel_5" title="Pixel 5">5</a></li>
                                          <li><a href="/wiki/Comparison_of_Google_Pixel_smartphones" title="Comparison of Google Pixel smartphones">Comparison</a></li>
                                       </ul>
                                    </li>
                                    <li><i><a href="/wiki/List_of_Google_Play_edition_devices" title="List of Google Play edition devices">Play Edition</a></i></li>
                                    <li><i><a href="/wiki/Project_Ara" title="Project Ara">Project Ara</a></i></li>
                                 </ul>
                              </li>
                           </ul>
                        </li>
                        <li><a href="/wiki/Sycamore_processor" title="Sycamore processor">Sycamore processor</a></li>
                        <li><a href="/wiki/Tensor_Processing_Unit" title="Tensor Processing Unit">Tensor Processing Unit</a></li>
                        <li>
                           Virtual reality/display
                           <ul>
                              <li><i><a href="/wiki/Google_Cardboard" title="Google Cardboard">Cardboard</a></i></li>
                              <li><i><a href="/wiki/Google_Contact_Lens" title="Google Contact Lens">Contact Lens</a></i></li>
                              <li><i><a href="/wiki/Google_Daydream" title="Google Daydream">Daydream</a></i></li>
                              <li><a href="/wiki/Google_Glass" title="Google Glass">Glass</a></li>
                           </ul>
                        </li>
                     </ul>
                  </div>
               </td>
            </tr>
            <tr style="display: none;">
               <th scope="row" class="navbox-group" style="width:1%">Related</th>
               <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                  <div style="padding:0em 0.25em">
                     <ul>
                        <li>
                           Documentaries
                           <ul>
                              <li><i><a href="/wiki/Google_Behind_the_Screen" title="Google Behind the Screen">Google: Behind the Screen</a></i></li>
                              <li><i><a href="/wiki/Google_Current" title="Google Current">Google Current</a></i></li>
                              <li><i><a href="/wiki/Google_Maps_Road_Trip" title="Google Maps Road Trip">Google Maps Road Trip</a></i></li>
                              <li><i><a href="/wiki/Google_The_Thinking_Factory" title="Google The Thinking Factory">Google: The Thinking Factory</a></i></li>
                              <li><i><a href="/wiki/Google_and_the_World_Brain" title="Google and the World Brain">Google and the World Brain</a></i></li>
                              <li><i><a href="/wiki/The_Creepy_Line" title="The Creepy Line">The Creepy Line</a></i></li>
                           </ul>
                        </li>
                        <li>
                           Terms and phrases
                           <ul>
                              <li>"<a href="/wiki/Don%27t_be_evil" title="Don't be evil">Don't be evil</a>"</li>
                              <li><a href="/wiki/Gayglers" title="Gayglers">Gayglers</a></li>
                              <li><a href="/wiki/Google_(verb)" title="Google (verb)">Google (verb)</a></li>
                              <li><a href="/wiki/Google_bombing" title="Google bombing">Google bombing</a></li>
                              <li><a href="/wiki/Google_Developer_Expert" title="Google Developer Expert">Google Developer Expert</a></li>
                              <li><a href="/wiki/Google_hacking" title="Google hacking">Google hacking</a></li>
                              <li><a href="/wiki/Googlization" title="Googlization">Googlization</a></li>
                              <li><a href="/wiki/Rooting_(Android)" title="Rooting (Android)">Rooting</a></li>
                           </ul>
                        </li>
                     </ul>
                  </div>
               </td>
            </tr>
            <tr style="display: none;">
               <td class="navbox-abovebelow" colspan="3">
                  <div>
                     <ul>
                        <li><i>Italics</i> indicate <a href="/wiki/List_of_Google_products#Discontinued_products_and_services" title="List of Google products">discontinued products, product lines and/or services</a></li>
                        <li><img alt="Category" src="//upload.wikimedia.org/wikipedia/en/thumb/9/96/Symbol_category_class.svg/16px-Symbol_category_class.svg.png" decoding="async" title="Category" width="16" height="16" srcset="//upload.wikimedia.org/wikipedia/en/thumb/9/96/Symbol_category_class.svg/23px-Symbol_category_class.svg.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/9/96/Symbol_category_class.svg/31px-Symbol_category_class.svg.png 2x" data-file-width="180" data-file-height="185"> <a href="/wiki/Category:Google" title="Category:Google">Category</a></li>
                        <li><a href="/wiki/File:Industry5.svg" class="image"><img alt="Industry5.svg" src="//upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Industry5.svg/28px-Industry5.svg.png" decoding="async" width="28" height="28" class="noviewer" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Industry5.svg/42px-Industry5.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Industry5.svg/56px-Industry5.svg.png 2x" data-file-width="512" data-file-height="512"></a>&nbsp;<a href="/wiki/Portal:Companies" title="Portal:Companies">Companies portal</a></li>
                        <li><a href="/wiki/File:Crystal_Clear_app_linneighborhood.svg" class="image"><img alt="Crystal Clear app linneighborhood.svg" src="//upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Crystal_Clear_app_linneighborhood.svg/28px-Crystal_Clear_app_linneighborhood.svg.png" decoding="async" width="28" height="28" class="noviewer" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Crystal_Clear_app_linneighborhood.svg/42px-Crystal_Clear_app_linneighborhood.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Crystal_Clear_app_linneighborhood.svg/56px-Crystal_Clear_app_linneighborhood.svg.png 2x" data-file-width="407" data-file-height="407"></a>&nbsp;<a href="/wiki/Portal:Internet" title="Portal:Internet">Internet portal</a></li>
                     </ul>
                  </div>
               </td>
            </tr>
         </tbody>
      </table>
   </div>
   <div role="navigation" class="navbox" aria-labelledby="Alphabet_Inc." style="padding:3px">
      <table class="nowraplinks hlist mw-collapsible autocollapse navbox-inner mw-made-collapsible mw-collapsed" style="border-spacing:0;background:transparent;color:inherit">
         <tbody>
            <tr>
               <th scope="col" class="navbox-title" colspan="3">
                  <span class="mw-collapsible-toggle mw-collapsible-toggle-default mw-collapsible-toggle-collapsed" role="button" tabindex="0" aria-expanded="false"><a class="mw-collapsible-text">show</a></span>
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r992953826">
                  <div class="navbar plainlinks hlist navbar-mini">
                     <ul>
                        <li class="nv-view"><a href="/wiki/Template:Alphabet_Inc." title="Template:Alphabet Inc."><abbr title="View this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">v</abbr></a></li>
                        <li class="nv-talk"><a href="/wiki/Template_talk:Alphabet_Inc." title="Template talk:Alphabet Inc."><abbr title="Discuss this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">t</abbr></a></li>
                        <li class="nv-edit"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Template:Alphabet_Inc.&amp;action=edit"><abbr title="Edit this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">e</abbr></a></li>
                     </ul>
                  </div>
                  <div id="Alphabet_Inc." style="font-size:114%;margin:0 4em"><a href="/wiki/Alphabet_Inc." title="Alphabet Inc.">Alphabet Inc.</a></div>
               </th>
            </tr>
            <tr style="display: none;">
               <th scope="row" class="navbox-group" style="width:1%">Subsidiaries</th>
               <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                  <div style="padding:0em 0.25em">
                     <ul>
                        <li>
                           Access
                           <ul>
                              <li><a href="/wiki/Google_Fiber" title="Google Fiber">Google Fiber</a></li>
                           </ul>
                        </li>
                        <li><a href="/wiki/Calico_(company)" title="Calico (company)">Calico</a></li>
                        <li><a href="/wiki/CapitalG" title="CapitalG">CapitalG</a></li>
                        <li><a href="/wiki/DeepMind" title="DeepMind">DeepMind</a></li>
                        <li><a href="/wiki/Fitbit" title="Fitbit">Fitbit</a></li>
                        <li>
                           <a class="mw-selflink selflink">Google</a>
                           <ul>
                              <li><a href="/wiki/Fitbit" title="Fitbit">Fitbit</a></li>
                              <li><a href="/wiki/Tenor_(website)" title="Tenor (website)">Tenor</a></li>
                              <li><a href="/wiki/Waze" title="Waze">Waze</a></li>
                              <li><a href="/wiki/YouTube" title="YouTube">YouTube</a></li>
                           </ul>
                        </li>
                        <li><a href="/wiki/GV_(company)" title="GV (company)">GV</a></li>
                        <li><a href="/wiki/Sidewalk_Labs" title="Sidewalk Labs">Sidewalk Labs</a></li>
                        <li><a href="/wiki/Verily" title="Verily">Verily</a></li>
                        <li><a href="/wiki/X_(company)" title="X (company)">X</a></li>
                        <li><a href="/wiki/Waymo" title="Waymo">Waymo</a></li>
                        <li><a href="/wiki/Wing_(company)" title="Wing (company)">Wing</a></li>
                     </ul>
                  </div>
               </td>
               <td class="noviewer navbox-image" rowspan="3" style="width:1px;padding:0px 0px 0px 2px">
                  <div><a href="/wiki/File:Alphabet_Inc_Logo_2015.svg" class="image" title="Logo of Alphabet Inc"><img alt="Logo of Alphabet Inc" src="//upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Alphabet_Inc_Logo_2015.svg/120px-Alphabet_Inc_Logo_2015.svg.png" decoding="async" width="120" height="29" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Alphabet_Inc_Logo_2015.svg/180px-Alphabet_Inc_Logo_2015.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Alphabet_Inc_Logo_2015.svg/240px-Alphabet_Inc_Logo_2015.svg.png 2x" data-file-width="512" data-file-height="124"></a></div>
               </td>
            </tr>
            <tr style="display: none;">
               <th scope="row" class="navbox-group" style="width:1%">Former</th>
               <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                  <div style="padding:0em 0.25em">
                     <ul>
                        <li><a href="/wiki/Chronicle_Security" title="Chronicle Security">Chronicle Security</a></li>
                        <li><a href="/wiki/Jigsaw_(company)" title="Jigsaw (company)">Jigsaw</a></li>
                        <li><a href="/wiki/Loon_LLC" title="Loon LLC">Loon</a></li>
                        <li><a href="/wiki/Makani_(company)" title="Makani (company)">Makani</a></li>
                        <li><a href="/wiki/Google_Nest" title="Google Nest">Nest Labs</a></li>
                     </ul>
                  </div>
               </td>
            </tr>
            <tr style="display: none;">
               <th scope="row" class="navbox-group" style="width:1%">People</th>
               <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                  <div style="padding:0em 0.25em">
                     <ul>
                        <li><a href="/wiki/Andrew_Conrad" title="Andrew Conrad">Andrew Conrad</a></li>
                        <li><a href="/wiki/Tony_Fadell" title="Tony Fadell">Tony Fadell</a></li>
                        <li><a href="/wiki/Arthur_D._Levinson" title="Arthur D. Levinson">Arthur D. Levinson</a></li>
                        <li><a href="/wiki/David_Krane" title="David Krane">David Krane</a></li>
                        <li><a href="/wiki/Ruth_Porat" title="Ruth Porat">Ruth Porat</a></li>
                        <li><a href="/wiki/Astro_Teller" title="Astro Teller">Astro Teller</a></li>
                     </ul>
                  </div>
                  <table class="nowraplinks navbox-subgroup" style="border-spacing:0">
                     <tbody>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Executives</th>
                           <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em"></div>
                              <table class="nowraplinks navbox-subgroup" style="border-spacing:0">
                                 <tbody>
                                    <tr>
                                       <th scope="row" class="navbox-group" style="width:1%">Current</th>
                                       <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                          <div style="padding:0em 0.25em">
                                             <ul>
                                                <li><a href="/wiki/Sundar_Pichai" title="Sundar Pichai">Sundar Pichai</a> (<a href="/wiki/Chief_executive_officer" title="Chief executive officer">CEO</a>)</li>
                                                <li><a href="/wiki/Ruth_Porat" title="Ruth Porat">Ruth Porat</a> (<a href="/wiki/Chief_financial_officer" title="Chief financial officer">CFO</a>)</li>
                                             </ul>
                                          </div>
                                       </td>
                                    </tr>
                                    <tr>
                                       <th scope="row" class="navbox-group" style="width:1%">Former</th>
                                       <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                          <div style="padding:0em 0.25em">
                                             <ul>
                                                <li><a href="/wiki/Larry_Page" title="Larry Page">Larry Page</a> (<a href="/wiki/Chief_executive_officer" title="Chief executive officer">CEO</a>)</li>
                                                <li><a href="/wiki/Sergey_Brin" title="Sergey Brin">Sergey Brin</a> (<a href="/wiki/President_(corporate_title)" title="President (corporate title)">President</a>)</li>
                                                <li><a href="/wiki/David_Drummond_(businessman)" title="David Drummond (businessman)">David Drummond</a> (<a href="/wiki/Chief_legal_officer" class="mw-redirect" title="Chief legal officer">CLO</a>)</li>
                                             </ul>
                                          </div>
                                       </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <div></div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Board_of_directors" title="Board of directors">Board of directors</a></th>
                           <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em"></div>
                              <table class="nowraplinks navbox-subgroup" style="border-spacing:0">
                                 <tbody>
                                    <tr>
                                       <th scope="row" class="navbox-group" style="width:1%">Current</th>
                                       <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                          <div style="padding:0em 0.25em">
                                             <ul>
                                                <li><a href="/wiki/Sergey_Brin" title="Sergey Brin">Sergey Brin</a></li>
                                                <li><a href="/wiki/John_Doerr" title="John Doerr">John Doerr</a></li>
                                                <li><a href="/wiki/John_L._Hennessy" title="John L. Hennessy">John L. Hennessy</a></li>
                                                <li><a href="/wiki/Ann_Mather" title="Ann Mather">Ann Mather</a></li>
                                                <li><a href="/wiki/Alan_Mulally" title="Alan Mulally">Alan Mulally</a></li>
                                                <li><a href="/wiki/Larry_Page" title="Larry Page">Larry Page</a></li>
                                                <li><a href="/wiki/Sundar_Pichai" title="Sundar Pichai">Sundar Pichai</a></li>
                                                <li><a href="/wiki/Ram_Shriram" title="Ram Shriram">Ram Shriram</a></li>
                                                <li><a href="/wiki/Roger_W._Ferguson_Jr." title="Roger W. Ferguson Jr.">Roger W. Ferguson Jr.</a></li>
                                             </ul>
                                          </div>
                                       </td>
                                    </tr>
                                    <tr>
                                       <th scope="row" class="navbox-group" style="width:1%">Former</th>
                                       <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                          <div style="padding:0em 0.25em">
                                             <ul>
                                                <li><a href="/wiki/Eric_Schmidt" title="Eric Schmidt">Eric Schmidt</a></li>
                                                <li><a href="/wiki/Diane_Greene" title="Diane Greene">Diane Greene</a></li>
                                             </ul>
                                          </div>
                                       </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <div></div>
                           </td>
                        </tr>
                        <tr>
                           <th scope="row" class="navbox-group" style="width:1%">Founders</th>
                           <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                              <div style="padding:0em 0.25em">
                                 <ul>
                                    <li><a href="/wiki/Larry_Page" title="Larry Page">Larry Page</a></li>
                                    <li><a href="/wiki/Sergey_Brin" title="Sergey Brin">Sergey Brin</a></li>
                                 </ul>
                              </div>
                           </td>
                        </tr>
                     </tbody>
                  </table>
                  <div></div>
               </td>
            </tr>
            <tr style="display: none;">
               <td class="navbox-abovebelow" colspan="3">
                  <div>
                     <ul>
                        <li><img alt="Category" src="//upload.wikimedia.org/wikipedia/en/thumb/9/96/Symbol_category_class.svg/16px-Symbol_category_class.svg.png" decoding="async" title="Category" width="16" height="16" srcset="//upload.wikimedia.org/wikipedia/en/thumb/9/96/Symbol_category_class.svg/23px-Symbol_category_class.svg.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/9/96/Symbol_category_class.svg/31px-Symbol_category_class.svg.png 2x" data-file-width="180" data-file-height="185"> <a href="/wiki/Category:Alphabet_Inc." title="Category:Alphabet Inc.">Category</a></li>
                        <li><a href="/wiki/File:Industry5.svg" class="image"><img alt="Industry5.svg" src="//upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Industry5.svg/28px-Industry5.svg.png" decoding="async" width="28" height="28" class="noviewer" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Industry5.svg/42px-Industry5.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Industry5.svg/56px-Industry5.svg.png 2x" data-file-width="512" data-file-height="512"></a>&nbsp;<a href="/wiki/Portal:Companies" title="Portal:Companies">Companies portal</a></li>
                        <li><a href="/wiki/File:Crystal_Clear_app_linneighborhood.svg" class="image"><img alt="Crystal Clear app linneighborhood.svg" src="//upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Crystal_Clear_app_linneighborhood.svg/28px-Crystal_Clear_app_linneighborhood.svg.png" decoding="async" width="28" height="28" class="noviewer" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Crystal_Clear_app_linneighborhood.svg/42px-Crystal_Clear_app_linneighborhood.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Crystal_Clear_app_linneighborhood.svg/56px-Crystal_Clear_app_linneighborhood.svg.png 2x" data-file-width="407" data-file-height="407"></a>&nbsp;<a href="/wiki/Portal:Internet" title="Portal:Internet">Internet portal</a></li>
                     </ul>
                  </div>
               </td>
            </tr>
         </tbody>
      </table>
   </div>
   <div role="navigation" class="navbox" aria-labelledby="Links_to_related_articles" style="padding:3px">
      <table class="nowraplinks mw-collapsible mw-collapsed navbox-inner mw-made-collapsible" style="border-spacing:0;background:transparent;color:inherit">
         <tbody>
            <tr>
               <th scope="col" class="navbox-title" colspan="2" style="background:#e8e8ff;">
                  <span class="mw-collapsible-toggle mw-collapsible-toggle-default mw-collapsible-toggle-collapsed" role="button" tabindex="0" aria-expanded="false"><a class="mw-collapsible-text">show</a></span>
                  <div id="Links_to_related_articles" style="font-size:114%;margin:0 4em">Links to related articles</div>
               </th>
            </tr>
            <tr style="display: none;">
               <td colspan="2" class="navbox-list navbox-odd" style="width:100%;padding:0px;font-size:114%">
                  <div style="padding:0px">
                     <div role="navigation" class="navbox" aria-labelledby="Open_Handset_Alliance" style="vertical-align: middle;;padding:3px">
                        <table class="nowraplinks mw-collapsible autocollapse navbox-inner mw-made-collapsible mw-collapsed" style="border-spacing:0;background:transparent;color:inherit">
                           <tbody>
                              <tr>
                                 <th scope="col" class="navbox-title" colspan="2">
                                    <span class="mw-collapsible-toggle mw-collapsible-toggle-default mw-collapsible-toggle-collapsed" role="button" tabindex="0" aria-expanded="false"><a class="mw-collapsible-text">show</a></span>
                                    <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r992953826">
                                    <div class="navbar plainlinks hlist navbar-mini">
                                       <ul>
                                          <li class="nv-view"><a href="/wiki/Template:Open_Handset_Alliance_Members" title="Template:Open Handset Alliance Members"><abbr title="View this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">v</abbr></a></li>
                                          <li class="nv-talk"><a href="/wiki/Template_talk:Open_Handset_Alliance_Members" title="Template talk:Open Handset Alliance Members"><abbr title="Discuss this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">t</abbr></a></li>
                                          <li class="nv-edit"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Template:Open_Handset_Alliance_Members&amp;action=edit"><abbr title="Edit this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">e</abbr></a></li>
                                       </ul>
                                    </div>
                                    <div id="Open_Handset_Alliance" style="font-size:114%;margin:0 4em"><a href="/wiki/Open_Handset_Alliance" title="Open Handset Alliance">Open Handset Alliance</a></div>
                                 </th>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Mobile_network_operator" title="Mobile network operator">Mobile operators</a></th>
                                 <td class="navbox-list navbox-odd hlist" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Bouygues_Telecom" title="Bouygues Telecom">Bouygues Telecom</a></li>
                                          <li><a href="/wiki/China_Mobile" title="China Mobile">China Mobile</a></li>
                                          <li><a href="/wiki/China_Telecommunications_Corporation" title="China Telecommunications Corporation">China Telecommunications Corporation</a></li>
                                          <li><a href="/wiki/China_Unicom" title="China Unicom">China Unicom</a></li>
                                          <li><a href="/wiki/Gruppo_TIM" title="Gruppo TIM">Gruppo TIM</a></li>
                                          <li><a href="/wiki/KDDI" title="KDDI">KDDI</a></li>
                                          <li><a href="/wiki/Nepal_Telecom" title="Nepal Telecom">Nepal Telecom</a></li>
                                          <li><a href="/wiki/NTT_Docomo" title="NTT Docomo">NTT Docomo</a></li>
                                          <li><a href="/wiki/SoftBank_Group" title="SoftBank Group">SoftBank Group</a></li>
                                          <li><a href="/wiki/Sprint_Corporation" title="Sprint Corporation">Sprint Corporation</a></li>
                                          <li><a href="/wiki/T-Mobile" title="T-Mobile">T-Mobile</a></li>
                                          <li><a href="/wiki/Telef%C3%B3nica" title="Telefónica">Telefónica</a></li>
                                          <li><a href="/wiki/Telus" title="Telus">Telus</a></li>
                                          <li><a href="/wiki/Vodafone" title="Vodafone">Vodafone</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Software" title="Software">Software companies</a></th>
                                 <td class="navbox-list navbox-even hlist" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Access_(company)" title="Access (company)">Access</a></li>
                                          <li><a href="/wiki/Ascender_Corporation" title="Ascender Corporation">Ascender Corporation</a></li>
                                          <li><a href="/wiki/EBay" title="EBay">eBay</a></li>
                                          <li><a class="mw-selflink selflink">Google</a></li>
                                          <li><a href="/wiki/Myriad_Group" title="Myriad Group">Myriad Group</a></li>
                                          <li><a href="/wiki/Nuance_Communications" title="Nuance Communications">Nuance Communications</a></li>
                                          <li><a href="/wiki/NXP_Semiconductors" title="NXP Semiconductors">NXP Software</a></li>
                                          <li><a href="/wiki/Omron" title="Omron">Omron</a></li>
                                          <li><a href="/wiki/PacketVideo" title="PacketVideo">PacketVideo</a></li>
                                          <li><a href="/wiki/SVOX" title="SVOX">SVOX</a></li>
                                          <li><a href="/wiki/VisualOn" title="VisualOn">VisualOn</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Semiconductor" title="Semiconductor">Semiconductor companies</a></th>
                                 <td class="navbox-list navbox-odd hlist" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/AKM_Semiconductor" class="mw-redirect" title="AKM Semiconductor">AKM Semiconductor</a></li>
                                          <li><a href="/wiki/Arm_Holdings" class="mw-redirect" title="Arm Holdings">Arm Holdings</a></li>
                                          <li><a href="/wiki/Audience_(company)" title="Audience (company)">Audience</a></li>
                                          <li><a href="/wiki/Broadcom_Corporation" title="Broadcom Corporation">Broadcom</a></li>
                                          <li><a href="/wiki/CSR_plc" class="mw-redirect" title="CSR plc">CSR plc</a> (joined as <a href="/wiki/SiRF" title="SiRF">SiRF</a>)</li>
                                          <li><a href="/wiki/Cypress_Semiconductor" title="Cypress Semiconductor">Cypress Semiconductor</a></li>
                                          <li><a href="/wiki/Freescale_Semiconductor" title="Freescale Semiconductor">Freescale Semiconductor</a></li>
                                          <li><a href="/wiki/Gemalto" title="Gemalto">Gemalto</a></li>
                                          <li><a href="/wiki/Intel" title="Intel">Intel</a></li>
                                          <li><a href="/wiki/Marvell_Technology_Group" title="Marvell Technology Group">Marvell Technology Group</a></li>
                                          <li><a href="/wiki/MediaTek" title="MediaTek">MediaTek</a></li>
                                          <li><a href="/wiki/MIPS_Technologies" title="MIPS Technologies">MIPS Technologies</a></li>
                                          <li><a href="/wiki/Nvidia" title="Nvidia">Nvidia</a></li>
                                          <li><a href="/wiki/Qualcomm" title="Qualcomm">Qualcomm</a></li>
                                          <li><a href="/wiki/Qualcomm_Atheros" title="Qualcomm Atheros">Qualcomm Atheros</a></li>
                                          <li><a href="/wiki/Renesas_Electronics" title="Renesas Electronics">Renesas Electronics</a></li>
                                          <li><a href="/wiki/ST-Ericsson" title="ST-Ericsson">ST-Ericsson</a> (joined as <a href="/wiki/Ericsson_Mobile_Platforms" title="Ericsson Mobile Platforms">Ericsson Mobile Platforms</a>)</li>
                                          <li><a href="/wiki/Synaptics" title="Synaptics">Synaptics</a></li>
                                          <li><a href="/wiki/Texas_Instruments" title="Texas Instruments">Texas Instruments</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Mobile_phone" title="Mobile phone">Handset makers</a></th>
                                 <td class="navbox-list navbox-even hlist" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Acer_Inc" class="mw-redirect" title="Acer Inc">Acer</a></li>
                                          <li><a href="/wiki/Alcatel_Mobile_Phones" class="mw-redirect" title="Alcatel Mobile Phones">Alcatel Mobile Phones</a></li>
                                          <li><a href="/wiki/Asus" title="Asus">Asus</a></li>
                                          <li><a href="/wiki/Chaudhary_Group" title="Chaudhary Group">Chaudhary Group</a> (with association of LG)</li>
                                          <li><a href="/wiki/Compal_Electronics" title="Compal Electronics">CCI</a></li>
                                          <li><a href="/wiki/Dell" title="Dell">Dell</a></li>
                                          <li><a href="/wiki/Foxconn" title="Foxconn">Foxconn</a></li>
                                          <li><a href="/wiki/Garmin" title="Garmin">Garmin</a></li>
                                          <li><a href="/wiki/HTC" title="HTC">HTC</a></li>
                                          <li><a href="/wiki/Huawei" title="Huawei">Huawei</a></li>
                                          <li><a href="/wiki/Kyocera" title="Kyocera">Kyocera</a></li>
                                          <li><a href="/wiki/Lenovo" title="Lenovo">Lenovo Mobile</a></li>
                                          <li><a href="/wiki/LG_Electronics" title="LG Electronics">LG Electronics</a></li>
                                          <li><a href="/wiki/Motorola_Mobility" title="Motorola Mobility">Motorola Mobility</a></li>
                                          <li><a href="/wiki/NEC" title="NEC">NEC Corporation</a></li>
                                          <li><a href="/wiki/Samsung_Electronics" title="Samsung Electronics">Samsung Electronics</a></li>
                                          <li><a href="/wiki/Sharp_Corporation" title="Sharp Corporation">Sharp Corporation</a></li>
                                          <li><a href="/wiki/Sony_Mobile" title="Sony Mobile">Sony Mobile</a></li>
                                          <li><a href="/wiki/Toshiba" title="Toshiba">Toshiba</a></li>
                                          <li><a href="/wiki/ZTE" title="ZTE">ZTE</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Marketing" title="Marketing">Commercialization companies</a></th>
                                 <td class="navbox-list navbox-odd hlist" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Accenture" title="Accenture">Accenture</a></li>
                                          <li><a href="/wiki/Borqs" title="Borqs">Borqs</a></li>
                                          <li><a href="/wiki/Sasken_Communication_Technologies" class="mw-redirect" title="Sasken Communication Technologies">Sasken Communication Technologies</a></li>
                                          <li><a href="/wiki/Teleca" class="mw-redirect" title="Teleca">Teleca</a></li>
                                          <li><a href="/wiki/The_Astonishing_Tribe" class="mw-redirect" title="The Astonishing Tribe">The Astonishing Tribe</a></li>
                                          <li><a href="/wiki/Wind_River_Systems" title="Wind River Systems">Wind River Systems</a></li>
                                          <li><a href="/wiki/Wipro_Technologies" class="mw-redirect" title="Wipro Technologies">Wipro Technologies</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%">See also</th>
                                 <td class="navbox-list navbox-even hlist" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Android_(operating_system)" title="Android (operating system)">Android</a></li>
                                          <li><a href="/wiki/Dalvik_(software)" title="Dalvik (software)">Dalvik virtual machine</a></li>
                                          <li><a href="/wiki/Google_Nexus" title="Google Nexus">Google Nexus</a></li>
                                          <li><a href="/wiki/HTC_Dream" title="HTC Dream">T-Mobile G1</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                           </tbody>
                        </table>
                     </div>
                     <div role="navigation" class="navbox" aria-labelledby="Google_Lunar_X_Prize" style="padding:3px">
                        <table class="nowraplinks hlist mw-collapsible autocollapse navbox-inner mw-made-collapsible mw-collapsed" style="border-spacing:0;background:transparent;color:inherit">
                           <tbody>
                              <tr>
                                 <th scope="col" class="navbox-title" colspan="2">
                                    <span class="mw-collapsible-toggle mw-collapsible-toggle-default mw-collapsible-toggle-collapsed" role="button" tabindex="0" aria-expanded="false"><a class="mw-collapsible-text">show</a></span>
                                    <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r992953826">
                                    <div class="navbar plainlinks hlist navbar-mini">
                                       <ul>
                                          <li class="nv-view"><a href="/wiki/Template:Google_Lunar_X_Prize" title="Template:Google Lunar X Prize"><abbr title="View this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">v</abbr></a></li>
                                          <li class="nv-talk"><a href="/wiki/Template_talk:Google_Lunar_X_Prize" title="Template talk:Google Lunar X Prize"><abbr title="Discuss this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">t</abbr></a></li>
                                          <li class="nv-edit"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Template:Google_Lunar_X_Prize&amp;action=edit"><abbr title="Edit this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">e</abbr></a></li>
                                       </ul>
                                    </div>
                                    <div id="Google_Lunar_X_Prize" style="font-size:114%;margin:0 4em"><a href="/wiki/Google_Lunar_X_Prize" title="Google Lunar X Prize">Google Lunar X Prize</a></div>
                                 </th>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%">Organizers</th>
                                 <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li>
                                             <a class="mw-selflink selflink">Google</a>
                                             <ul>
                                                <li><a href="/wiki/Sundar_Pichai" title="Sundar Pichai">Sundar Pichai</a></li>
                                                <li><a href="/wiki/Larry_Page" title="Larry Page">Larry Page</a></li>
                                                <li><a href="/wiki/Sergey_Brin" title="Sergey Brin">Sergey Brin</a></li>
                                             </ul>
                                          </li>
                                          <li>
                                             <a href="/wiki/X_Prize_Foundation" title="X Prize Foundation">X Prize Foundation</a>
                                             <ul>
                                                <li><a href="/wiki/Peter_Diamandis" title="Peter Diamandis">Peter Diamandis</a></li>
                                             </ul>
                                          </li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%">Finalist teams</th>
                                 <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Hakuto" title="Hakuto">Hakuto</a></li>
                                          <li><a href="/wiki/Moon_Express" title="Moon Express">Moon Express</a></li>
                                          <li><a href="/wiki/SpaceIL" title="SpaceIL">SpaceIL</a></li>
                                          <li><a href="/wiki/Synergy_Moon" title="Synergy Moon">Synergy Moon</a></li>
                                          <li><a href="/wiki/TeamIndus" title="TeamIndus">TeamIndus</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%">Withdrawn teams</th>
                                 <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li>Advaeros</li>
                                          <li><a href="/wiki/Team_AngelicvM" title="Team AngelicvM">AngelicvM</a></li>
                                          <li><a href="/wiki/ARCA_Space_Corporation" class="mw-redirect" title="ARCA Space Corporation">ARCA</a></li>
                                          <li><a href="/wiki/Astrobotic_Technology" title="Astrobotic Technology">Astrobotic</a></li>
                                          <li><a href="/wiki/Barcelona_Moon_Team" title="Barcelona Moon Team">Barcelona Moon Team</a></li>
                                          <li>C-Base Open Moon</li>
                                          <li><a href="/wiki/Euroluna" title="Euroluna">Euroluna</a></li>
                                          <li><a href="/wiki/Team_FREDNET" title="Team FREDNET">FREDNET</a></li>
                                          <li><a href="/wiki/Independence-X_Aerospace" title="Independence-X Aerospace">Independence-X</a></li>
                                          <li>JURBAN</li>
                                          <li>LunaTrex</li>
                                          <li><a href="/wiki/Micro-Space" title="Micro-Space">Micro-Space</a></li>
                                          <li>Mystical Moon</li>
                                          <li>Next Giant Leap</li>
                                          <li><a href="/wiki/Odyssey_Moon" title="Odyssey Moon">Odyssey Moon</a></li>
                                          <li>Omega Envoy</li>
                                          <li><a href="/wiki/PTScientists" title="PTScientists">Part-Time Scientists</a></li>
                                          <li><a href="/wiki/Penn_State_Lunar_Lion_Team" title="Penn State Lunar Lion Team">Penn State Lunar Lion Team</a></li>
                                          <li><a href="/wiki/Puli_Space_Technologies" title="Puli Space Technologies">Team Puli</a></li>
                                          <li>Quantum3</li>
                                          <li><a href="/wiki/Rocket_City_Space_Pioneers" title="Rocket City Space Pioneers">Rocket City Space Pioneers</a></li>
                                          <li>SCSG</li>
                                          <li><a href="/wiki/Selenokhod" title="Selenokhod">Selenokhod</a></li>
                                          <li><a href="/wiki/SpaceMETA" title="SpaceMETA">SpaceMETA</a></li>
                                          <li>STELLAR</li>
                                          <li>Team Italia</li>
                                          <li>Team Phoenicia</li>
                                          <li>Team Plan B</li>
                                          <li>Team SELENE</li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%">Spacecraft</th>
                                 <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/PTScientists" title="PTScientists">ALINA</a> (Part-Time Scientists)</li>
                                          <li><i><a href="/wiki/Beresheet" title="Beresheet">Beresheet</a></i> (SpaceIL)</li>
                                          <li><a href="/wiki/TeamIndus" title="TeamIndus">HHK-1 / ECA</a> (TeamIndus)</li>
                                          <li><a href="/wiki/MX-1E" class="mw-redirect" title="MX-1E">MX-1E</a> (Moon Express)</li>
                                          <li><a href="/wiki/Astrobotic" class="mw-redirect" title="Astrobotic">Peregrine</a> (Astrobotic)</li>
                                          <li><a href="/wiki/Hakuto" title="Hakuto">SORATO</a> (Hakuto)</li>
                                          <li><a href="/wiki/Synergy_Moon" title="Synergy Moon">Tesla</a> (Synergy Moon)</li>
                                          <li><a href="/wiki/Team_AngelicvM" title="Team AngelicvM"><i>Unity</i></a> (AngelicvM)</li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                           </tbody>
                        </table>
                     </div>
                     <div role="navigation" class="navbox" aria-labelledby="Major_mobile_device_companies" style="padding:3px">
                        <table class="nowraplinks hlist mw-collapsible autocollapse navbox-inner mw-made-collapsible mw-collapsed" style="border-spacing:0;background:transparent;color:inherit">
                           <tbody>
                              <tr>
                                 <th scope="col" class="navbox-title" colspan="2">
                                    <span class="mw-collapsible-toggle mw-collapsible-toggle-default mw-collapsible-toggle-collapsed" role="button" tabindex="0" aria-expanded="false"><a class="mw-collapsible-text">show</a></span>
                                    <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r992953826">
                                    <div class="navbar plainlinks hlist navbar-mini">
                                       <ul>
                                          <li class="nv-view"><a href="/wiki/Template:Major_mobile_device_companies" title="Template:Major mobile device companies"><abbr title="View this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">v</abbr></a></li>
                                          <li class="nv-talk"><a href="/wiki/Template_talk:Major_mobile_device_companies" title="Template talk:Major mobile device companies"><abbr title="Discuss this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">t</abbr></a></li>
                                          <li class="nv-edit"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Template:Major_mobile_device_companies&amp;action=edit"><abbr title="Edit this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">e</abbr></a></li>
                                       </ul>
                                    </div>
                                    <div id="Major_mobile_device_companies" style="font-size:114%;margin:0 4em">Major <a href="/wiki/Mobile_device" title="Mobile device">mobile device</a> companies</div>
                                 </th>
                              </tr>
                              <tr style="display: none;">
                                 <td class="navbox-abovebelow" colspan="2">
                                    <div id="Companies_with_an_annual_revenue_of_over_US$3_billion">Companies with an annual revenue of over US$3 billion</div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <td colspan="2" class="navbox-list navbox-odd" style="width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Acer_Inc." title="Acer Inc.">Acer</a></li>
                                          <li><a href="/wiki/Alba_(brand)" title="Alba (brand)">Alba</a></li>
                                          <li><a href="/wiki/Amazon_(company)" title="Amazon (company)">Amazon</a></li>
                                          <li><a href="/wiki/Apple_Inc." title="Apple Inc.">Apple</a></li>
                                          <li><a href="/wiki/Asus" title="Asus">Asus</a></li>
                                          <li>
                                             <a href="/wiki/BBK_Electronics" title="BBK Electronics">BBK Electronics</a>
                                             <ul>
                                                <li><a href="/wiki/Oppo" title="Oppo">Oppo</a></li>
                                                <li><a href="/wiki/OnePlus" title="OnePlus">OnePlus</a></li>
                                                <li><a href="/wiki/Vivo_(technology_company)" title="Vivo (technology company)">Vivo</a></li>
                                                <li><a href="/wiki/Realme" title="Realme">Realme</a></li>
                                                <li><a href="/wiki/IQOO" title="IQOO">iQOO</a></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/BlackBerry_Limited" title="BlackBerry Limited">BlackBerry Limited</a></li>
                                          <li><a href="/wiki/Bush_(brand)" title="Bush (brand)">Bush</a></li>
                                          <li><a href="/wiki/Dell" title="Dell">Dell</a></li>
                                          <li><a href="/wiki/Fitbit" title="Fitbit">Fitbit</a></li>
                                          <li>
                                             <a href="/wiki/Foxconn" title="Foxconn">Foxconn</a>
                                             <ul>
                                                <li><a href="/wiki/Sharp_Corporation" title="Sharp Corporation">Sharp</a></li>
                                                <li><a href="/wiki/InFocus" title="InFocus">InFocus</a></li>
                                                <li><a href="/wiki/Nokia" title="Nokia">Nokia</a></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/Fujitsu" title="Fujitsu">Fujitsu</a></li>
                                          <li><a href="/wiki/GeeksPhone" title="GeeksPhone">GeeksPhone</a></li>
                                          <li>
                                             <a class="mw-selflink selflink">Google</a>
                                             <ul>
                                                <li><a href="/wiki/Chromebook" title="Chromebook">Chromebook</a></li>
                                                <li><a href="/wiki/Google_Pixel" title="Google Pixel">Google Pixel</a></li>
                                                <li><a href="/wiki/Android_One" title="Android One">Android One</a></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/HTC" title="HTC">HTC</a></li>
                                          <li><a href="/wiki/HP_Inc." title="HP Inc.">HP</a></li>
                                          <li>
                                             <a href="/wiki/Huawei" title="Huawei">Huawei</a>
                                             <ul>
                                                <li><a href="/wiki/Honor_(brand)" title="Honor (brand)">Honor</a></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/Intel" title="Intel">Intel</a></li>
                                          <li>
                                             <a href="/wiki/Lenovo" title="Lenovo">Lenovo</a>
                                             <ul>
                                                <li><a href="/wiki/Motorola_Mobility" title="Motorola Mobility">Motorola Mobility</a></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/LG_Electronics" title="LG Electronics">LG Electronics</a></li>
                                          <li><a href="/wiki/Meizu" title="Meizu">Meizu</a></li>
                                          <li>
                                             <a href="/wiki/Microsoft" title="Microsoft">Microsoft</a>
                                             <ul>
                                                <li><a href="/wiki/Microsoft_Lumia" title="Microsoft Lumia">Microsoft Lumia</a></li>
                                                <li><a href="/wiki/Microsoft_Surface" title="Microsoft Surface">Microsoft Surface</a></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/Motorola_Solutions" title="Motorola Solutions">Motorola Solutions</a></li>
                                          <li>
                                             <a href="/wiki/HMD_Global" title="HMD Global">HMD Global</a>
                                             <ul>
                                                <li><a href="/wiki/Nokia" title="Nokia">Nokia</a></li>
                                             </ul>
                                          </li>
                                          <li>Kurio</li>
                                          <li>Onyx Boox</li>
                                          <li><a href="/wiki/Panasonic" title="Panasonic">Panasonic</a></li>
                                          <li><a href="/wiki/RCA" title="RCA">RCA</a></li>
                                          <li><a href="/wiki/Samsung_Electronics" title="Samsung Electronics">Samsung Electronics</a></li>
                                          <li><a href="/wiki/Sony" title="Sony">Sony</a></li>
                                          <li>
                                             <a href="/wiki/TCL_Technology" title="TCL Technology">TCL</a>
                                             <ul>
                                                <li><a href="/wiki/BlackBerry_Mobile" title="BlackBerry Mobile">BlackBerry Mobile</a></li>
                                                <li><a href="/wiki/Alcatel_Mobile" title="Alcatel Mobile">Alcatel Mobile</a></li>
                                                <li><a href="/wiki/Palm,_Inc." title="Palm, Inc.">Palm</a></li>
                                                <li>TCL Communication</li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/Toshiba" title="Toshiba">Toshiba</a></li>
                                          <li>
                                             <a href="/wiki/Transsion" title="Transsion">Transsion</a>
                                             <ul>
                                                <li><a href="/wiki/Tecno_Mobile" title="Tecno Mobile">Tecno</a></li>
                                                <li><a href="/wiki/Infinix_Mobile" title="Infinix Mobile">Infinix</a></li>
                                                <li><a href="/wiki/Itel_Mobile" title="Itel Mobile">Itel</a></li>
                                             </ul>
                                          </li>
                                          <li>
                                             <a href="/wiki/Tinno_Mobile" title="Tinno Mobile">Tinno Mobile</a>
                                             <ul>
                                                <li><a href="/wiki/Wiko" title="Wiko">Wiko</a></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/True_Corporation" title="True Corporation">True</a></li>
                                          <li><a href="/wiki/Vaio" title="Vaio">Vaio</a></li>
                                          <li><a href="/wiki/VinSmart" title="VinSmart">VinSmart</a></li>
                                          <li>
                                             <a href="/wiki/Xiaomi" title="Xiaomi">Xiaomi</a>
                                             <ul>
                                                <li><a href="/wiki/Redmi" title="Redmi">Redmi</a></li>
                                                <li><a href="/wiki/List_of_Xiaomi_products#POCO_series" title="List of Xiaomi products">POCO</a></li>
                                                <li><a href="/wiki/Meitu" title="Meitu">Meitu</a></li>
                                                <li>Black Shark</li>
                                             </ul>
                                          </li>
                                          <li>
                                             <a href="/wiki/ZTE" title="ZTE">ZTE</a>
                                             <ul>
                                                <li><a href="/wiki/Nubia_Technology" title="Nubia Technology">Nubia</a></li>
                                             </ul>
                                          </li>
                                          <li><a href="/wiki/Walton_Micro-Tech_Corporation" title="Walton Micro-Tech Corporation">Walton Mobile</a></li>
                                          <li>Zoostorm</li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <td class="navbox-abovebelow" colspan="2">
                                    <div>
                                       <dl>
                                          <dt>See also</dt>
                                          <dd><a href="/wiki/List_of_largest_technology_companies_by_revenue" title="List of largest technology companies by revenue">Largest IT companies</a></dd>
                                          <dd><a href="/wiki/Category:Mobile_technology_companies" title="Category:Mobile technology companies">Category:Mobile technology companies</a></dd>
                                          <dd><a href="/wiki/Category:Mobile_phone_manufacturers" title="Category:Mobile phone manufacturers">Category:Mobile phone manufacturers</a></dd>
                                       </dl>
                                    </div>
                                 </td>
                              </tr>
                           </tbody>
                        </table>
                     </div>
                     <div role="navigation" class="navbox" aria-labelledby="Major_Internet_companies" style="padding:3px">
                        <table class="nowraplinks hlist mw-collapsible autocollapse navbox-inner mw-made-collapsible mw-collapsed" style="border-spacing:0;background:transparent;color:inherit">
                           <tbody>
                              <tr>
                                 <th scope="col" class="navbox-title" colspan="2">
                                    <span class="mw-collapsible-toggle mw-collapsible-toggle-default mw-collapsible-toggle-collapsed" role="button" tabindex="0" aria-expanded="false"><a class="mw-collapsible-text">show</a></span>
                                    <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r992953826">
                                    <div class="navbar plainlinks hlist navbar-mini">
                                       <ul>
                                          <li class="nv-view"><a href="/wiki/Template:Major_Internet_companies" title="Template:Major Internet companies"><abbr title="View this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">v</abbr></a></li>
                                          <li class="nv-talk"><a href="/wiki/Template_talk:Major_Internet_companies" title="Template talk:Major Internet companies"><abbr title="Discuss this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">t</abbr></a></li>
                                          <li class="nv-edit"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Template:Major_Internet_companies&amp;action=edit"><abbr title="Edit this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">e</abbr></a></li>
                                       </ul>
                                    </div>
                                    <div id="Major_Internet_companies" style="font-size:114%;margin:0 4em">Major <a href="/wiki/Internet" title="Internet">Internet</a> companies</div>
                                 </th>
                              </tr>
                              <tr style="display: none;">
                                 <td class="navbox-abovebelow" colspan="2">
                                    <div id="Companies_with_an_annual_revenue_of_over_US$4_billion">Companies with an annual revenue of over US$4 billion</div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/List_of_largest_Internet_companies" title="List of largest Internet companies">Internet </a></th>
                                 <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Adobe_Inc." title="Adobe Inc.">Adobe Inc.</a></li>
                                          <li><a href="/wiki/Alibaba_Group" title="Alibaba Group">Alibaba</a></li>
                                          <li><a href="/wiki/Alphabet_Inc." title="Alphabet Inc.">Alphabet</a> (<a class="mw-selflink selflink">Google</a>)</li>
                                          <li><a href="/wiki/Amazon_(company)" title="Amazon (company)">Amazon</a></li>
                                          <li><a href="/wiki/Apple_Inc." title="Apple Inc.">Apple</a></li>
                                          <li><a href="/wiki/Baidu" title="Baidu">Baidu</a></li>
                                          <li><a href="/wiki/Facebook,_Inc." title="Facebook, Inc.">Facebook</a></li>
                                          <li><a href="/wiki/IAC_(company)" title="IAC (company)">InterActiveCorp</a></li>
                                          <li><a href="/wiki/Meituan" title="Meituan">Meituan</a></li>
                                          <li><a href="/wiki/Microsoft" title="Microsoft">Microsoft</a></li>
                                          <li><a href="/wiki/Naver_Corporation" title="Naver Corporation">Naver</a></li>
                                          <li><a href="/wiki/NetEase" title="NetEase">NetEase</a></li>
                                          <li><a href="/wiki/Tencent" title="Tencent">Tencent</a></li>
                                          <li><a href="/wiki/Yandex" title="Yandex">Yandex</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%">Cloud computing</th>
                                 <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Akamai_Technologies" title="Akamai Technologies">Akamai</a></li>
                                          <li><a href="/wiki/Alibaba_Cloud" title="Alibaba Cloud">Alibaba Cloud</a></li>
                                          <li><a href="/wiki/Amazon_Web_Services" title="Amazon Web Services">AWS</a></li>
                                          <li><a href="/wiki/ICloud" title="ICloud">Apple iCloud</a></li>
                                          <li><a href="/wiki/Google_Cloud_Platform" title="Google Cloud Platform">Google</a></li>
                                          <li><a href="/wiki/IBM_cloud_computing" title="IBM cloud computing">IBM</a></li>
                                          <li><a href="/wiki/Microsoft_Azure" title="Microsoft Azure">Microsoft Azure</a></li>
                                          <li><a href="/wiki/Oracle_Corporation" title="Oracle Corporation">Oracle Corporation</a></li>
                                          <li><a href="/wiki/Rackspace_Technology" title="Rackspace Technology">Rackspace Technology</a></li>
                                          <li><a href="/wiki/Salesforce" title="Salesforce">Salesforce</a></li>
                                          <li><a href="/wiki/ServiceNow" title="ServiceNow">ServiceNow</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%">E-commerce</th>
                                 <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Amazon_(company)" title="Amazon (company)">Amazon.com</a></li>
                                          <li><a href="/wiki/Apple_Inc." title="Apple Inc.">Apple</a></li>
                                          <li><a href="/wiki/Booking_Holdings" title="Booking Holdings">Booking Holdings</a></li>
                                          <li><a href="/wiki/Coupang" title="Coupang">Coupang</a></li>
                                          <li><a href="/wiki/EBay" title="EBay">eBay</a></li>
                                          <li><a href="/wiki/Expedia" title="Expedia">Expedia</a></li>
                                          <li><a href="/wiki/Flipkart" title="Flipkart">Flipkart</a></li>
                                          <li><a href="/wiki/Groupon" title="Groupon">Groupon</a></li>
                                          <li><a href="/wiki/JD.com" title="JD.com">JD.com</a></li>
                                          <li><a href="/wiki/Lazada" class="mw-redirect" title="Lazada">Lazada</a></li>
                                          <li><a href="/wiki/Rakuten" title="Rakuten">Rakuten</a></li>
                                          <li><a href="/wiki/Shopee" title="Shopee">Shopee</a></li>
                                          <li><a href="/wiki/Shopify" title="Shopify">Shopify</a></li>
                                          <li><a href="/wiki/Suning.com" title="Suning.com">Suning.com</a></li>
                                          <li><a href="/wiki/Trip.com" title="Trip.com">Trip.com</a></li>
                                          <li><a href="/wiki/Uber" title="Uber">Uber</a></li>
                                          <li><a href="/wiki/Wayfair" title="Wayfair">Wayfair</a></li>
                                          <li><a href="/wiki/Zalando" title="Zalando">Zalando</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%">Media</th>
                                 <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Bloomberg_L.P." title="Bloomberg L.P.">Bloomberg L.P.</a></li>
                                          <li><a href="/wiki/ByteDance" title="ByteDance">ByteDance</a></li>
                                          <li><a href="/wiki/Dotdash" title="Dotdash">Dotdash</a> (owned by <a href="/wiki/IAC_(company)" title="IAC (company)">InterActiveCorp</a>)</li>
                                          <li><a href="/wiki/Kuaishou" title="Kuaishou">Kuaishou</a></li>
                                          <li><a href="/wiki/G/O_Media" title="G/O Media">G/O Media</a></li>
                                          <li><a href="/wiki/Netflix" title="Netflix">Netflix</a></li>
                                          <li><a href="/wiki/Spotify" title="Spotify">Spotify</a></li>
                                          <li><a href="/wiki/Verizon_Media" title="Verizon Media">Verizon Media</a></li>
                                          <li><a href="/wiki/ViacomCBS_Streaming" title="ViacomCBS Streaming">ViacomCBS Streaming</a></li>
                                          <li><a href="/wiki/Vox_Media" title="Vox Media">Vox Media</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <td class="navbox-abovebelow" colspan="2">
                                    <div>
                                       <dl>
                                          <dt>See also</dt>
                                          <dd><a href="/wiki/List_of_largest_technology_companies_by_revenue" title="List of largest technology companies by revenue">Largest IT companies</a></dd>
                                          <dd><a href="/wiki/List_of_largest_Internet_companies" title="List of largest Internet companies">List of largest Internet companies</a></dd>
                                          <dd><a href="/wiki/Category:Internet_technology_companies" title="Category:Internet technology companies">Category:Internet technology companies</a></dd>
                                       </dl>
                                    </div>
                                 </td>
                              </tr>
                           </tbody>
                        </table>
                     </div>
                     <div role="navigation" class="navbox" aria-labelledby="Major_software_companies" style="padding:3px">
                        <table class="nowraplinks hlist mw-collapsible autocollapse navbox-inner mw-made-collapsible mw-collapsed" style="border-spacing:0;background:transparent;color:inherit">
                           <tbody>
                              <tr>
                                 <th scope="col" class="navbox-title" colspan="2">
                                    <span class="mw-collapsible-toggle mw-collapsible-toggle-default mw-collapsible-toggle-collapsed" role="button" tabindex="0" aria-expanded="false"><a class="mw-collapsible-text">show</a></span>
                                    <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r992953826">
                                    <div class="navbar plainlinks hlist navbar-mini">
                                       <ul>
                                          <li class="nv-view"><a href="/wiki/Template:Major_software_companies" title="Template:Major software companies"><abbr title="View this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">v</abbr></a></li>
                                          <li class="nv-talk"><a href="/wiki/Template_talk:Major_software_companies" title="Template talk:Major software companies"><abbr title="Discuss this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">t</abbr></a></li>
                                          <li class="nv-edit"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Template:Major_software_companies&amp;action=edit"><abbr title="Edit this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">e</abbr></a></li>
                                       </ul>
                                    </div>
                                    <div id="Major_software_companies" style="font-size:114%;margin:0 4em">Major <a href="/wiki/Software" title="Software">software</a> companies</div>
                                 </th>
                              </tr>
                              <tr style="display: none;">
                                 <td class="navbox-abovebelow" colspan="2">
                                    <div id="Companies_with_annual_software_revenue_of_over_US$3_billion">Companies with annual software revenue of over US$3 billion</div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <td colspan="2" class="navbox-list navbox-odd" style="width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Adobe_Inc" class="mw-redirect" title="Adobe Inc">Adobe</a></li>
                                          <li><a href="/wiki/Amadeus_IT_Group" title="Amadeus IT Group">Amadeus IT Group</a></li>
                                          <li><a href="/wiki/Amazon_(company)" title="Amazon (company)">Amazon</a></li>
                                          <li><a href="/wiki/Apple_Inc" class="mw-redirect" title="Apple Inc">Apple</a></li>
                                          <li><a href="/wiki/Autodesk" title="Autodesk">Autodesk</a></li>
                                          <li><a href="/wiki/Citrix_Systems" title="Citrix Systems">Citrix</a></li>
                                          <li><a href="/wiki/FIS_(company)" title="FIS (company)">FIS</a></li>
                                          <li><a class="mw-selflink selflink">Google</a></li>
                                          <li><a href="/wiki/Hewlett_Packard_Enterprise" title="Hewlett Packard Enterprise">HPE</a></li>
                                          <li><a href="/wiki/IBM" title="IBM">IBM</a></li>
                                          <li><a href="/wiki/Intuit" title="Intuit">Intuit</a></li>
                                          <li><a href="/wiki/Infor" title="Infor">Infor</a></li>
                                          <li><a href="/wiki/Microsoft" title="Microsoft">Microsoft</a></li>
                                          <li><a href="/wiki/Oracle_Corporation" title="Oracle Corporation">Oracle</a></li>
                                          <li><a href="/wiki/Quest_Software" title="Quest Software">Quest Software</a></li>
                                          <li><a href="/wiki/Sage_Group" title="Sage Group">Sage Group</a></li>
                                          <li><a href="/wiki/SAP" title="SAP">SAP</a></li>
                                          <li><a href="/wiki/Tencent" title="Tencent">Tencent</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <td class="navbox-abovebelow" colspan="2">
                                    <div>
                                       <dl>
                                          <dt>See also</dt>
                                          <dd><a href="/wiki/List_of_largest_technology_companies_by_revenue" title="List of largest technology companies by revenue">Largest IT companies</a></dd>
                                          <dd><a href="/wiki/List_of_the_largest_software_companies" title="List of the largest software companies">Largest software companies</a></dd>
                                          <dd><a href="/wiki/Category:Software_companies" title="Category:Software companies">Category:Software companies</a></dd>
                                       </dl>
                                    </div>
                                 </td>
                              </tr>
                           </tbody>
                        </table>
                     </div>
                     <div role="navigation" class="navbox" aria-labelledby="Laureates_of_the_Prince_or_Princess_of_Asturias_Award_for_Communication_and_Humanities" style="padding:3px">
                        <table class="nowraplinks mw-collapsible mw-collapsed navbox-inner mw-made-collapsible" style="border-spacing:0;background:transparent;color:inherit">
                           <tbody>
                              <tr>
                                 <th scope="col" class="navbox-title" colspan="3" style="background:#99d6ff;">
                                    <span class="mw-collapsible-toggle mw-collapsible-toggle-default mw-collapsible-toggle-collapsed" role="button" tabindex="0" aria-expanded="false"><a class="mw-collapsible-text">show</a></span>
                                    <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r992953826">
                                    <div class="navbar plainlinks hlist navbar-mini">
                                       <ul>
                                          <li class="nv-view"><a href="/wiki/Template:Princess_of_Asturias_Award_for_Communication_and_Humanities" title="Template:Princess of Asturias Award for Communication and Humanities"><abbr title="View this template" style="background:#99d6ff;;;background:none transparent;border:none;box-shadow:none;padding:0;">v</abbr></a></li>
                                          <li class="nv-talk"><a href="/wiki/Template_talk:Princess_of_Asturias_Award_for_Communication_and_Humanities" title="Template talk:Princess of Asturias Award for Communication and Humanities"><abbr title="Discuss this template" style="background:#99d6ff;;;background:none transparent;border:none;box-shadow:none;padding:0;">t</abbr></a></li>
                                          <li class="nv-edit"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Template:Princess_of_Asturias_Award_for_Communication_and_Humanities&amp;action=edit"><abbr title="Edit this template" style="background:#99d6ff;;;background:none transparent;border:none;box-shadow:none;padding:0;">e</abbr></a></li>
                                       </ul>
                                    </div>
                                    <div id="Laureates_of_the_Prince_or_Princess_of_Asturias_Award_for_Communication_and_Humanities" style="font-size:114%;margin:0 4em">Laureates of the <a href="/wiki/Princess_of_Asturias_Awards" title="Princess of Asturias Awards">Prince or Princess of Asturias Award</a> for Communication and Humanities</div>
                                 </th>
                              </tr>
                              <tr style="display: none;">
                                 <td colspan="2" class="navbox-list navbox-odd hlist" style="width:100%;padding:0px">
                                    <div style="padding:0em 0.25em"></div>
                                    <table class="nowraplinks navbox-subgroup" style="border-spacing:0">
                                       <tbody>
                                          <tr>
                                             <th scope="col" class="navbox-title" colspan="2" style="background:#addeff;">
                                                <div id="Prince_of_Asturias_Award_for_Communication_and_Humanities" style="font-size:114%;margin:0 4em"><small>Prince of Asturias Award for Communication and Humanities</small></div>
                                             </th>
                                          </tr>
                                          <tr>
                                             <th scope="row" class="navbox-group" style="background:#addeff;;width:1%">1980s</th>
                                             <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                                <div style="padding:0em 0.25em">
                                                   <ul>
                                                      <li>1981: <a href="/wiki/Mar%C3%ADa_Zambrano" title="María Zambrano">María Zambrano</a></li>
                                                      <li>1982: <a href="/wiki/Mario_Bunge" title="Mario Bunge">Mario Bunge</a></li>
                                                      <li>1983: <i><a href="/wiki/El_Pa%C3%ADs" title="El País">El País</a></i> newspaper</li>
                                                      <li>1984: <a href="/wiki/Claudio_S%C3%A1nchez-Albornoz" title="Claudio Sánchez-Albornoz">Claudio Sánchez-Albornoz</a></li>
                                                      <li>1985: <a href="/wiki/Jos%C3%A9_Ferrater_Mora" title="José Ferrater Mora">José Ferrater Mora</a></li>
                                                      <li>1986: <a href="/wiki/Grupo_Globo" class="mw-redirect" title="Grupo Globo">Grupo Globo</a></li>
                                                      <li>1987: <i><a href="/wiki/El_Espectador" title="El Espectador">El Espectador</a></i> and <i><a href="/wiki/El_Tiempo_(Colombia)" title="El Tiempo (Colombia)">El Tiempo</a></i> newspapers</li>
                                                      <li>1988: <a href="/w/index.php?title=Horacio_S%C3%A1enz_Guerrero&amp;action=edit&amp;redlink=1" class="new" title="Horacio Sáenz Guerrero (page does not exist)">Horacio Sáenz Guerrero</a></li>
                                                      <li>1989: <a href="/wiki/Pedro_La%C3%ADn_Entralgo" title="Pedro Laín Entralgo">Pedro Laín Entralgo</a> and <a href="/wiki/Fondo_de_Cultura_Econ%C3%B3mica" title="Fondo de Cultura Económica">Fondo de Cultura Económica</a></li>
                                                   </ul>
                                                </div>
                                             </td>
                                          </tr>
                                          <tr>
                                             <th scope="row" class="navbox-group" style="background:#addeff;;width:1%">1990s</th>
                                             <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                                <div style="padding:0em 0.25em">
                                                   <ul>
                                                      <li>1990: <a href="/wiki/Central_American_University" title="Central American University">José Simeón Cañas Central American University</a></li>
                                                      <li>1991: <a href="/w/index.php?title=Luis_Mar%C3%ADa_Anson&amp;action=edit&amp;redlink=1" class="new" title="Luis María Anson (page does not exist)">Luis María Anson</a></li>
                                                      <li>1992: <a href="/wiki/Emilio_Garc%C3%ADa_G%C3%B3mez" title="Emilio García Gómez">Emilio García Gómez</a></li>
                                                      <li>1993: <i><a href="/wiki/Vuelta_(magazine)" title="Vuelta (magazine)">Vuelta</a></i> magazine by <a href="/wiki/Octavio_Paz" title="Octavio Paz">Octavio Paz</a></li>
                                                      <li>1994: Spanish <a href="/wiki/Mission_(Christian)" class="mw-redirect" title="Mission (Christian)">Missions</a> in <a href="/wiki/Rwanda" title="Rwanda">Rwanda</a> and <a href="/wiki/Burundi" title="Burundi">Burundi</a></li>
                                                      <li>1995: <a href="/wiki/EFE" title="EFE">EFE Agency</a> and <a href="/w/index.php?title=Jos%C3%A9_Luis_L%C3%B3pez_Aranguren&amp;action=edit&amp;redlink=1" class="new" title="José Luis López Aranguren (page does not exist)">José Luis López Aranguren</a></li>
                                                      <li>1996: <a href="/wiki/Indro_Montanelli" title="Indro Montanelli">Indro Montanelli</a> and <a href="/wiki/Juli%C3%A1n_Mar%C3%ADas" title="Julián Marías">Julián Marías</a></li>
                                                      <li>1997: <a href="/wiki/V%C3%A1clav_Havel" title="Václav Havel">Václav Havel</a> and <a href="/wiki/CNN" title="CNN">CNN</a></li>
                                                      <li>1998: <a href="/wiki/Reinhard_Mohn" title="Reinhard Mohn">Reinhard Mohn</a></li>
                                                      <li>1999: <a href="/wiki/Caro_and_Cuervo_Institute" title="Caro and Cuervo Institute">Caro and Cuervo Institute</a></li>
                                                   </ul>
                                                </div>
                                             </td>
                                          </tr>
                                          <tr>
                                             <th scope="row" class="navbox-group" style="background:#addeff;;width:1%">2000s</th>
                                             <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                                <div style="padding:0em 0.25em">
                                                   <ul>
                                                      <li>2000: <a href="/wiki/Umberto_Eco" title="Umberto Eco">Umberto Eco</a></li>
                                                      <li>2001: <a href="/wiki/George_Steiner" title="George Steiner">George Steiner</a></li>
                                                      <li>2002: <a href="/wiki/Hans_Magnus_Enzensberger" title="Hans Magnus Enzensberger">Hans Magnus Enzensberger</a></li>
                                                      <li>2003: <a href="/wiki/Ryszard_Kapu%C5%9Bci%C5%84ski" title="Ryszard Kapuściński">Ryszard Kapuściński</a> and <a href="/wiki/Gustavo_Guti%C3%A9rrez" title="Gustavo Gutiérrez">Gustavo Gutiérrez Merino</a></li>
                                                      <li>2004: <a href="/wiki/Jean_Daniel" title="Jean Daniel">Jean Daniel</a></li>
                                                      <li>2005: <a href="/wiki/Alliance_Fran%C3%A7aise" class="mw-redirect" title="Alliance Française">Alliance Française</a>, <a href="/wiki/Dante_Alighieri_Society" title="Dante Alighieri Society">Società Dante Alighieri</a>, <a href="/wiki/British_Council" title="British Council">British Council</a>, <a href="/wiki/Goethe-Institut" title="Goethe-Institut">Goethe-Institut</a>, <a href="/wiki/Instituto_Cervantes" title="Instituto Cervantes">Instituto Cervantes</a> and <a href="/wiki/Instituto_Cam%C3%B5es" title="Instituto Camões">Instituto Camões</a></li>
                                                      <li>2006: <a href="/wiki/National_Geographic_Society" title="National Geographic Society">National Geographic Society</a></li>
                                                      <li>2007: <i><a href="/wiki/Nature_(journal)" title="Nature (journal)">Nature</a></i> and <i><a href="/wiki/Science_(journal)" title="Science (journal)">Science</a></i> journals</li>
                                                      <li>2008: <a class="mw-selflink selflink">Google</a></li>
                                                      <li>2009: <a href="/wiki/National_Autonomous_University_of_Mexico" title="National Autonomous University of Mexico">National Autonomous University of Mexico</a></li>
                                                   </ul>
                                                </div>
                                             </td>
                                          </tr>
                                          <tr>
                                             <th scope="row" class="navbox-group" style="background:#addeff;;width:1%">2010s</th>
                                             <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                                <div style="padding:0em 0.25em">
                                                   <ul>
                                                      <li>2010: <a href="/wiki/Alain_Touraine" title="Alain Touraine">Alain Touraine</a> and <a href="/wiki/Zygmunt_Bauman" title="Zygmunt Bauman">Zygmunt Bauman</a></li>
                                                      <li>2011: <a href="/wiki/Royal_Society" title="Royal Society">Royal Society</a></li>
                                                      <li>2012: <a href="/wiki/Shigeru_Miyamoto" title="Shigeru Miyamoto">Shigeru Miyamoto</a></li>
                                                      <li>2013: <a href="/wiki/Annie_Leibovitz" title="Annie Leibovitz">Annie Leibovitz</a></li>
                                                      <li>2014: <a href="/wiki/Quino" title="Quino">Quino</a></li>
                                                   </ul>
                                                </div>
                                             </td>
                                          </tr>
                                       </tbody>
                                    </table>
                                    <div></div>
                                 </td>
                                 <td class="noviewer navbox-image" rowspan="2" style="width:1px;padding:0px 0px 0px 2px">
                                    <div><a href="/wiki/File:Princess_of_Asturias_Foundation_Emblem.svg" class="image"><img alt="Princess of Asturias Foundation Emblem.svg" src="//upload.wikimedia.org/wikipedia/commons/thumb/7/70/Princess_of_Asturias_Foundation_Emblem.svg/50px-Princess_of_Asturias_Foundation_Emblem.svg.png" decoding="async" width="50" height="68" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/7/70/Princess_of_Asturias_Foundation_Emblem.svg/75px-Princess_of_Asturias_Foundation_Emblem.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/7/70/Princess_of_Asturias_Foundation_Emblem.svg/100px-Princess_of_Asturias_Foundation_Emblem.svg.png 2x" data-file-width="952" data-file-height="1296"></a></div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <td colspan="2" class="navbox-list navbox-odd hlist" style="width:100%;padding:0px">
                                    <div style="padding:0em 0.25em"></div>
                                    <table class="nowraplinks navbox-subgroup" style="border-spacing:0">
                                       <tbody>
                                          <tr>
                                             <th scope="col" class="navbox-title" colspan="2" style="background:#addeff;">
                                                <div id="Princess_of_Asturias_Award_for_Communication_and_Humanities" style="font-size:114%;margin:0 4em"><small>Princess of Asturias Award for Communication and Humanities</small></div>
                                             </th>
                                          </tr>
                                          <tr>
                                             <th scope="row" class="navbox-group" style="background:#addeff;;width:1%">2010s</th>
                                             <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                                <div style="padding:0em 0.25em">
                                                   <ul>
                                                      <li>2015: <a href="/wiki/Emilio_Lled%C3%B3" title="Emilio Lledó">Emilio Lledó Íñigo</a></li>
                                                      <li>2016: <a href="/wiki/James_Nachtwey" title="James Nachtwey">James Nachtwey</a></li>
                                                      <li>2017: <a href="/wiki/Les_Luthiers" title="Les Luthiers">Les Luthiers</a></li>
                                                      <li>2018: <a href="/wiki/Alma_Guillermoprieto" title="Alma Guillermoprieto">Alma Guillermoprieto</a></li>
                                                      <li>2019: <a href="/wiki/Museo_del_Prado" title="Museo del Prado">Museo del Prado</a></li>
                                                   </ul>
                                                </div>
                                             </td>
                                          </tr>
                                          <tr>
                                             <th scope="row" class="navbox-group" style="background:#addeff;;width:1%">2020s</th>
                                             <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                                <div style="padding:0em 0.25em">
                                                   <ul>
                                                      <li>2020: <a href="/wiki/Guadalajara_International_Book_Fair" title="Guadalajara International Book Fair">Guadalajara International Book Fair</a> and <a href="/wiki/Hay_Festival" title="Hay Festival">Hay Festival of Literature &amp; Arts</a></li>
                                                   </ul>
                                                </div>
                                             </td>
                                          </tr>
                                       </tbody>
                                    </table>
                                    <div></div>
                                 </td>
                              </tr>
                           </tbody>
                        </table>
                     </div>
                     <div role="navigation" class="navbox" aria-labelledby="Electronics_industry_in_the_United_States" style="padding:3px">
                        <table class="nowraplinks hlist mw-collapsible autocollapse navbox-inner mw-made-collapsible mw-collapsed" style="border-spacing:0;background:transparent;color:inherit">
                           <tbody>
                              <tr>
                                 <th scope="col" class="navbox-title" colspan="2">
                                    <span class="mw-collapsible-toggle mw-collapsible-toggle-default mw-collapsible-toggle-collapsed" role="button" tabindex="0" aria-expanded="false"><a class="mw-collapsible-text">show</a></span>
                                    <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r992953826">
                                    <div class="navbar plainlinks hlist navbar-mini">
                                       <ul>
                                          <li class="nv-view"><a href="/wiki/Template:Electronics_industry_in_the_United_States" title="Template:Electronics industry in the United States"><abbr title="View this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">v</abbr></a></li>
                                          <li class="nv-talk"><a href="/wiki/Template_talk:Electronics_industry_in_the_United_States" title="Template talk:Electronics industry in the United States"><abbr title="Discuss this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">t</abbr></a></li>
                                          <li class="nv-edit"><a class="external text" href="https://en.wikipedia.org/w/index.php?title=Template:Electronics_industry_in_the_United_States&amp;action=edit"><abbr title="Edit this template" style=";;background:none transparent;border:none;box-shadow:none;padding:0;">e</abbr></a></li>
                                       </ul>
                                    </div>
                                    <div id="Electronics_industry_in_the_United_States" style="font-size:114%;margin:0 4em"><a href="/wiki/Electronics_industry_in_the_United_States" class="mw-redirect" title="Electronics industry in the United States">Electronics industry in the United States</a></div>
                                 </th>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%">Companies</th>
                                 <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em"></div>
                                    <table class="nowraplinks navbox-subgroup" style="border-spacing:0">
                                       <tbody>
                                          <tr>
                                             <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Home_appliance" title="Home appliance">Home appliances</a></th>
                                             <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                                <div style="padding:0em 0.25em">
                                                   <ul>
                                                      <li><a href="/wiki/Apple_Inc." title="Apple Inc.">Apple</a></li>
                                                      <li><a href="/wiki/Bose_Corporation" title="Bose Corporation">Bose</a></li>
                                                      <li><a href="/wiki/Cisco_Systems" title="Cisco Systems">Cisco Systems</a></li>
                                                      <li><a href="/wiki/Corsair_Gaming" title="Corsair Gaming">Corsair</a></li>
                                                      <li><a href="/wiki/Dell" title="Dell">Dell</a></li>
                                                      <li><a href="/wiki/Dolby_Laboratories" title="Dolby Laboratories">Dolby Laboratories</a></li>
                                                      <li><a href="/wiki/Element_Electronics" title="Element Electronics">Element Electronics</a></li>
                                                      <li><a href="/wiki/Emerson_Radio" title="Emerson Radio">Emerson Radio</a></li>
                                                      <li>
                                                         <a href="/wiki/Harman_International_Industries" class="mw-redirect" title="Harman International Industries">Harman</a>
                                                         <ul>
                                                            <li><a href="/wiki/JBL_(company)" class="mw-redirect" title="JBL (company)">JBL</a></li>
                                                         </ul>
                                                      </li>
                                                      <li><a href="/wiki/Honeywell" title="Honeywell">Honeywell</a></li>
                                                      <li><a href="/wiki/HP_Inc." title="HP Inc.">HP</a></li>
                                                      <li><a href="/wiki/InFocus" title="InFocus">InFocus</a></li>
                                                      <li><a href="/wiki/Jensen_Electronics" title="Jensen Electronics">Jensen Electronics</a></li>
                                                      <li><a href="/wiki/Kenmore_(brand)" title="Kenmore (brand)">Kenmore</a></li>
                                                      <li><a href="/wiki/Kingston_Technology" title="Kingston Technology">Kingston</a></li>
                                                      <li><a href="/wiki/Kimball_International" title="Kimball International">Kimball</a></li>
                                                      <li><a href="/wiki/Koss_Corporation" title="Koss Corporation">Koss</a></li>
                                                      <li><a href="/wiki/Lexmark" title="Lexmark">Lexmark</a></li>
                                                      <li><a href="/wiki/Logitech" title="Logitech">Logitech</a></li>
                                                      <li><a href="/wiki/Magnavox" title="Magnavox">Magnavox</a></li>
                                                      <li><a href="/wiki/Marantz" title="Marantz">Marantz</a></li>
                                                      <li><a href="/wiki/Memorex" title="Memorex">Memorex</a></li>
                                                      <li><a href="/wiki/Microsoft" title="Microsoft">Microsoft</a></li>
                                                      <li><a href="/wiki/Monster_Cable" title="Monster Cable">Monster</a></li>
                                                      <li><a href="/wiki/Plantronics" title="Plantronics">Plantronics</a></li>
                                                      <li><a href="/wiki/Planar_Systems" title="Planar Systems">Planar Systems</a></li>
                                                      <li><a href="/wiki/Pyle_USA" title="Pyle USA">Pyle USA</a></li>
                                                      <li><a href="/wiki/Razer_Inc." title="Razer Inc.">Razer</a></li>
                                                      <li><a href="/wiki/Seagate_Technology" title="Seagate Technology">Seagate</a></li>
                                                      <li><a href="/wiki/Seiki_Digital" title="Seiki Digital">Seiki Digital</a></li>
                                                      <li><a href="/wiki/Skullcandy" title="Skullcandy">Skullcandy</a></li>
                                                      <li><a href="/wiki/Turtle_Beach_Corporation" title="Turtle Beach Corporation">Turtle Beach</a></li>
                                                      <li><a href="/wiki/ViewSonic" title="ViewSonic">ViewSonic</a></li>
                                                      <li><a href="/wiki/Vizio_Inc." class="mw-redirect" title="Vizio Inc.">Vizio Inc.</a></li>
                                                      <li>
                                                         <a href="/wiki/Western_Digital" title="Western Digital">Western Digital</a>
                                                         <ul>
                                                            <li><a href="/wiki/HGST" title="HGST">HGST</a></li>
                                                            <li><a href="/wiki/SanDisk" title="SanDisk">SanDisk</a></li>
                                                         </ul>
                                                      </li>
                                                      <li><a href="/wiki/Westinghouse_Electric_Company" title="Westinghouse Electric Company">Westinghouse Electric Company</a></li>
                                                      <li><a href="/wiki/Westinghouse_Electronics" title="Westinghouse Electronics">Westinghouse Electronics</a></li>
                                                      <li><a href="/wiki/Xerox" title="Xerox">Xerox</a></li>
                                                   </ul>
                                                </div>
                                             </td>
                                          </tr>
                                          <tr>
                                             <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Electronic_component" title="Electronic component">Electronic components</a></th>
                                             <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                                <div style="padding:0em 0.25em">
                                                   <ul>
                                                      <li><a href="/wiki/3M" title="3M">3M</a></li>
                                                      <li><a href="/wiki/Achronix" title="Achronix">Achronix</a></li>
                                                      <li><a href="/wiki/Analog_Devices" title="Analog Devices">Analog Devices</a></li>
                                                      <li><a href="/wiki/Applied_Materials" title="Applied Materials">Applied Materials</a></li>
                                                      <li><a href="/wiki/Altera" title="Altera">Altera</a></li>
                                                      <li><a href="/wiki/AVX_Corporation" title="AVX Corporation">AVX</a></li>
                                                      <li><a href="/wiki/Cirque_Corporation" title="Cirque Corporation">Cirque</a></li>
                                                      <li><a href="/wiki/Diodes_Incorporated" title="Diodes Incorporated">Diodes Inc.</a></li>
                                                      <li><a href="/wiki/Flex_(company)" title="Flex (company)">Flex</a></li>
                                                      <li><a href="/wiki/Jabil" title="Jabil">Jabil</a></li>
                                                      <li><a href="/wiki/KEMET_Corporation" title="KEMET Corporation">KEMET</a></li>
                                                      <li><a href="/wiki/Maxwell_Technologies" title="Maxwell Technologies">Maxwell Technologies</a></li>
                                                      <li><a href="/wiki/Sanmina_Corporation" title="Sanmina Corporation">Sanmina</a></li>
                                                      <li><a href="/wiki/Vishay_Intertechnology" title="Vishay Intertechnology">Vishay</a></li>
                                                   </ul>
                                                </div>
                                             </td>
                                          </tr>
                                          <tr>
                                             <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Semiconductor_device" title="Semiconductor device">Semiconductor devices</a></th>
                                             <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                                <div style="padding:0em 0.25em">
                                                   <ul>
                                                      <li><a href="/wiki/Advanced_Micro_Devices" title="Advanced Micro Devices">AMD</a></li>
                                                      <li><a href="/wiki/Ampere_Computing" title="Ampere Computing">Ampere Computing</a></li>
                                                      <li><a href="/wiki/Apple-designed_processors" title="Apple-designed processors">Apple</a></li>
                                                      <li><a href="/wiki/Broadcom_Inc." title="Broadcom Inc.">Broadcom</a></li>
                                                      <li><a href="/wiki/Cypress_Semiconductor" title="Cypress Semiconductor">Cypress Semiconductor</a></li>
                                                      <li><a href="/wiki/GlobalFoundries" title="GlobalFoundries">GlobalFoundries</a></li>
                                                      <li><a href="/wiki/IBM" title="IBM">IBM</a></li>
                                                      <li><a href="/wiki/Intel" title="Intel">Intel</a></li>
                                                      <li><a href="/wiki/Interlink_Electronics" title="Interlink Electronics">Interlink</a></li>
                                                      <li><a href="/wiki/KLA-Tencor" class="mw-redirect" title="KLA-Tencor">KLA-Tencor</a></li>
                                                      <li><a href="/wiki/Lam_Research" title="Lam Research">Lam Research</a></li>
                                                      <li><a href="/wiki/Lattice_Semiconductor" title="Lattice Semiconductor">Lattice</a></li>
                                                      <li><a href="/wiki/Marvell_Technology_Group" title="Marvell Technology Group">Marvell Technology</a></li>
                                                      <li><a href="/wiki/Mellanox_Technologies" title="Mellanox Technologies">Mellanox</a></li>
                                                      <li><a href="/wiki/Microchip_Technology" title="Microchip Technology">Microchip</a> (<a href="/wiki/Atmel" title="Atmel">Atmel</a>)</li>
                                                      <li><a href="/wiki/Micron_Technology" title="Micron Technology">Micron</a></li>
                                                      <li><a href="/wiki/NetApp" title="NetApp">NetApp</a></li>
                                                      <li><a href="/wiki/Nimbus_Data" title="Nimbus Data">Nimbus Data</a></li>
                                                      <li><a href="/wiki/Nvidia" title="Nvidia">Nvidia</a></li>
                                                      <li><a href="/wiki/NXP_Semiconductors" title="NXP Semiconductors">NXP</a></li>
                                                      <li><a href="/wiki/ON_Semiconductor" title="ON Semiconductor">ON Semiconductor</a></li>
                                                      <li><a href="/wiki/Qualcomm" title="Qualcomm">Qualcomm</a></li>
                                                      <li><a href="/wiki/Synaptics" title="Synaptics">Synaptics</a></li>
                                                      <li><a href="/wiki/Silicon_Graphics" title="Silicon Graphics">Silicon Graphics</a></li>
                                                      <li><a href="/wiki/Silicon_Image" title="Silicon Image">Silicon Image</a></li>
                                                      <li><a href="/wiki/Tabula_(company)" title="Tabula (company)">Tabula</a></li>
                                                      <li><a href="/wiki/Texas_Instruments" title="Texas Instruments">Texas Instruments</a></li>
                                                      <li><a href="/wiki/Xilinx" title="Xilinx">Xilinx</a></li>
                                                      <li><a href="/wiki/Zilog" title="Zilog">Zilog</a></li>
                                                   </ul>
                                                </div>
                                             </td>
                                          </tr>
                                          <tr>
                                             <th scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Mobile_device" title="Mobile device">Mobile devices</a></th>
                                             <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                                <div style="padding:0em 0.25em">
                                                   <ul>
                                                      <li><a href="/wiki/Apple_Inc." title="Apple Inc.">Apple</a></li>
                                                      <li><a href="/wiki/BLU_Products" title="BLU Products">BLU</a></li>
                                                      <li><a class="mw-selflink selflink">Google</a></li>
                                                      <li><a href="/wiki/Lenovo" title="Lenovo">Lenovo</a> (<a href="/wiki/Motorola_Mobility" title="Motorola Mobility">Motorola Mobility</a>)</li>
                                                   </ul>
                                                </div>
                                             </td>
                                          </tr>
                                          <tr>
                                             <th scope="row" class="navbox-group" style="width:1%">Other</th>
                                             <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                                <div style="padding:0em 0.25em">
                                                   <ul>
                                                      <li><a href="/wiki/Cadence_Design_Systems" title="Cadence Design Systems">Cadence Design Systems</a></li>
                                                      <li><a href="/wiki/Cray" title="Cray">Cray</a></li>
                                                      <li>
                                                         <a href="/wiki/General_Electric" title="General Electric">GE</a>
                                                         <ul>
                                                            <li><a href="/wiki/RCA_(trademark)" title="RCA (trademark)">RCA</a></li>
                                                         </ul>
                                                      </li>
                                                      <li><a href="/wiki/Oracle_Corporation" title="Oracle Corporation">Oracle Corporation</a></li>
                                                      <li><a href="/wiki/Synopsys" title="Synopsys">Synopsys</a></li>
                                                   </ul>
                                                </div>
                                             </td>
                                          </tr>
                                       </tbody>
                                    </table>
                                    <div></div>
                                 </td>
                              </tr>
                              <tr style="display: none;">
                                 <th scope="row" class="navbox-group" style="width:1%">Defunct</th>
                                 <td class="navbox-list navbox-even" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                                    <div style="padding:0em 0.25em">
                                       <ul>
                                          <li><a href="/wiki/Actel" title="Actel">Actel</a></li>
                                          <li><a href="/wiki/Commodore_International" title="Commodore International">Commodore</a></li>
                                          <li><a href="/wiki/Compaq" title="Compaq">Compaq</a></li>
                                          <li><a href="/wiki/Fairchild_Semiconductor" title="Fairchild Semiconductor">Fairchild</a></li>
                                          <li><a href="/wiki/Freescale_Semiconductor" title="Freescale Semiconductor">Freescale</a></li>
                                          <li><a href="/wiki/LSI_Corporation" title="LSI Corporation">LSI</a></li>
                                          <li><a href="/wiki/Microsemi" title="Microsemi">Microsemi</a></li>
                                          <li><a href="/wiki/National_Semiconductor" title="National Semiconductor">National Semiconductor</a></li>
                                          <li><a href="/wiki/Palm,_Inc." title="Palm, Inc.">Palm</a></li>
                                          <li><a href="/wiki/Philco" title="Philco">Philco</a></li>
                                          <li><a href="/wiki/RCA" title="RCA">RCA</a></li>
                                          <li><a href="/wiki/Signetics" title="Signetics">Signetics</a></li>
                                          <li><a href="/wiki/Solectron" title="Solectron">Solectron</a></li>
                                          <li><a href="/wiki/Sun_Microsystems" title="Sun Microsystems">Sun Microsystems</a></li>
                                          <li><a href="/wiki/Zenith_Electronics" title="Zenith Electronics">Zenith Electronics</a></li>
                                       </ul>
                                    </div>
                                 </td>
                              </tr>
                           </tbody>
                        </table>
                     </div>
                  </div>
               </td>
            </tr>
         </tbody>
      </table>
   </div>
   <div class="noprint metadata navbox" role="navigation" aria-label="Portals" style="font-weight:bold;padding:0.4em 2em">
      <ul style="margin:0.1em 0 0">
         <li style="display:inline"><span style="display:inline-block;white-space:nowrap"><span style="margin:0 0.5em"><a href="/wiki/File:Industry5.svg" class="image"><img alt="Industry5.svg" src="//upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Industry5.svg/21px-Industry5.svg.png" decoding="async" width="21" height="21" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Industry5.svg/32px-Industry5.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Industry5.svg/42px-Industry5.svg.png 2x" data-file-width="512" data-file-height="512"></a></span><a href="/wiki/Portal:Companies" title="Portal:Companies">Companies portal</a></span></li>
         <li style="display:inline"><span style="display:inline-block;white-space:nowrap"><span style="margin:0 0.5em"><a href="/wiki/File:Octicons-terminal.svg" class="image"><img alt="Octicons-terminal.svg" src="//upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Octicons-terminal.svg/18px-Octicons-terminal.svg.png" decoding="async" width="18" height="21" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Octicons-terminal.svg/28px-Octicons-terminal.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Octicons-terminal.svg/37px-Octicons-terminal.svg.png 2x" data-file-width="896" data-file-height="1024"></a></span><a href="/wiki/Portal:Computer_programming" title="Portal:Computer programming">Computer programming portal</a></span></li>
         <li style="display:inline"><span style="display:inline-block;white-space:nowrap"><span style="margin:0 0.5em"><a href="/wiki/File:Crystal_Clear_app_linneighborhood.svg" class="image"><img alt="Crystal Clear app linneighborhood.svg" src="//upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Crystal_Clear_app_linneighborhood.svg/21px-Crystal_Clear_app_linneighborhood.svg.png" decoding="async" width="21" height="21" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Crystal_Clear_app_linneighborhood.svg/32px-Crystal_Clear_app_linneighborhood.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Crystal_Clear_app_linneighborhood.svg/42px-Crystal_Clear_app_linneighborhood.svg.png 2x" data-file-width="407" data-file-height="407"></a></span><a href="/wiki/Portal:Internet" title="Portal:Internet">Internet portal</a></span></li>
         <li style="display:inline"><span style="display:inline-block;white-space:nowrap"><span style="margin:0 0.5em"><a href="/wiki/File:SF_From_Marin_Highlands3.jpg" class="image"><img alt="SF From Marin Highlands3.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/d/da/SF_From_Marin_Highlands3.jpg/24px-SF_From_Marin_Highlands3.jpg" decoding="async" width="24" height="17" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/d/da/SF_From_Marin_Highlands3.jpg/36px-SF_From_Marin_Highlands3.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/d/da/SF_From_Marin_Highlands3.jpg/48px-SF_From_Marin_Highlands3.jpg 2x" data-file-width="2672" data-file-height="1885"></a></span><a href="/wiki/Portal:San_Francisco_Bay_Area" title="Portal:San Francisco Bay Area">San Francisco Bay Area portal</a></span></li>
         <li style="display:inline"><span style="display:inline-block;white-space:nowrap"><span style="margin:0 0.5em"><a href="/wiki/File:Flag_of_Singapore.svg" class="image"><img alt="Flag of Singapore.svg" src="//upload.wikimedia.org/wikipedia/commons/thumb/4/48/Flag_of_Singapore.svg/24px-Flag_of_Singapore.svg.png" decoding="async" width="24" height="16" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/4/48/Flag_of_Singapore.svg/36px-Flag_of_Singapore.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/4/48/Flag_of_Singapore.svg/48px-Flag_of_Singapore.svg.png 2x" data-file-width="4320" data-file-height="2880"></a></span><a href="/wiki/Portal:Singapore" title="Portal:Singapore">Singapore portal</a></span></li>
         <li style="display:inline"><span style="display:inline-block;white-space:nowrap"><span style="margin:0 0.5em"><a href="/wiki/File:Telecom-icon.svg" class="image"><img alt="Telecom-icon.svg" src="//upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Telecom-icon.svg/21px-Telecom-icon.svg.png" decoding="async" width="21" height="21" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Telecom-icon.svg/32px-Telecom-icon.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Telecom-icon.svg/42px-Telecom-icon.svg.png 2x" data-file-width="512" data-file-height="512"></a></span><a href="/wiki/Portal:Technology" title="Portal:Technology">Technology portal</a></span></li>
      </ul>
   </div>
   <div role="navigation" class="navbox authority-control" aria-labelledby="Authority_control_frameless_&amp;#124;text-top_&amp;#124;10px_&amp;#124;alt=Edit_this_at_Wikidata_&amp;#124;link=https&amp;#58;//www.wikidata.org/wiki/Q95#identifiers&amp;#124;Edit_this_at_Wikidata" style="padding:3px">
      <table class="nowraplinks hlist navbox-inner" style="border-spacing:0;background:transparent;color:inherit">
         <tbody>
            <tr>
               <th id="Authority_control_frameless_&amp;#124;text-top_&amp;#124;10px_&amp;#124;alt=Edit_this_at_Wikidata_&amp;#124;link=https&amp;#58;//www.wikidata.org/wiki/Q95#identifiers&amp;#124;Edit_this_at_Wikidata" scope="row" class="navbox-group" style="width:1%"><a href="/wiki/Help:Authority_control" title="Help:Authority control">Authority control</a> <a href="https://www.wikidata.org/wiki/Q95#identifiers" title="Edit this at Wikidata"><img alt="Edit this at Wikidata" src="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/10px-OOjs_UI_icon_edit-ltr-progressive.svg.png" decoding="async" width="10" height="10" style="vertical-align: text-top" srcset="//upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/15px-OOjs_UI_icon_edit-ltr-progressive.svg.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/8/8a/OOjs_UI_icon_edit-ltr-progressive.svg/20px-OOjs_UI_icon_edit-ltr-progressive.svg.png 2x" data-file-width="20" data-file-height="20"></a></th>
               <td class="navbox-list navbox-odd" style="text-align:left;border-left-width:2px;border-left-style:solid;width:100%;padding:0px">
                  <div style="padding:0em 0.25em">
                     <ul>
                        <li><span class="nowrap"><a href="/wiki/BIBSYS_(identifier)" class="mw-redirect" title="BIBSYS (identifier)">BIBSYS</a>: <span class="uid"><a rel="nofollow" class="external text" href="https://authority.bibsys.no/authority/rest/authorities/html/4092379">4092379</a></span></span></li>
                        <li><span class="nowrap"><a href="/wiki/BNF_(identifier)" class="mw-redirect" title="BNF (identifier)">BNF</a>: <span class="uid"><a rel="nofollow" class="external text" href="https://catalogue.bnf.fr/ark:/12148/cb15026135n">cb15026135n</a> <a rel="nofollow" class="external text" href="https://data.bnf.fr/ark:/12148/cb15026135n">(data)</a></span></span></li>
                        <li><span class="nowrap"><a href="/wiki/CANTIC_(identifier)" class="mw-redirect" title="CANTIC (identifier)">CANTIC</a>: <span class="uid"><a rel="nofollow" class="external text" href="http://cantic.bnc.cat/registres/CUCId/a10914717">a10914717</a></span></span></li>
                        <li><span class="nowrap"><a href="/wiki/GND_(identifier)" class="mw-redirect" title="GND (identifier)">GND</a>: <span class="uid"><a rel="nofollow" class="external text" href="https://d-nb.info/gnd/10122609-3">10122609-3</a></span></span></li>
                        <li><span class="nowrap"><a href="/wiki/ISNI_(identifier)" class="mw-redirect" title="ISNI (identifier)">ISNI</a>: <span class="uid"><a rel="nofollow" class="external text" href="https://isni.org/isni/0000000406356729">0000 0004 0635 6729</a></span></span></li>
                        <li><span class="nowrap"><a href="/wiki/LCCN_(identifier)" class="mw-redirect" title="LCCN (identifier)">LCCN</a>: <span class="uid"><a rel="nofollow" class="external text" href="https://id.loc.gov/authorities/names/no00095539">no00095539</a></span></span></li>
                        <li><span class="nowrap"><a href="/wiki/MA_(identifier)" class="mw-redirect" title="MA (identifier)">MA</a>: <span class="uid"><a rel="nofollow" class="external text" href="https://academic.microsoft.com/v2/detail/1291425158">1291425158</a></span></span></li>
                        <li><span class="nowrap"><a href="/wiki/NKC_(identifier)" class="mw-redirect" title="NKC (identifier)">NKC</a>: <span class="uid"><a rel="nofollow" class="external text" href="https://aleph.nkp.cz/F/?func=find-c&amp;local_base=aut&amp;ccl_term=ica=kn20050213003&amp;CON_LNG=ENG">kn20050213003</a></span></span></li>
                        <li><span class="nowrap"><a href="/wiki/NLA_(identifier)" class="mw-redirect" title="NLA (identifier)">NLA</a>: <span class="uid"><a rel="nofollow" class="external text" href="https://nla.gov.au/anbd.aut-an50414901">50414901</a></span></span></li>
                        <li><span class="nowrap"><a href="/wiki/SELIBR_(identifier)" class="mw-redirect" title="SELIBR (identifier)">SELIBR</a>: <span class="uid"><a rel="nofollow" class="external text" href="https://libris.kb.se/auth/293303">293303</a></span></span></li>
                        <li><span class="nowrap"><a href="/wiki/SUDOC_(identifier)" class="mw-redirect" title="SUDOC (identifier)">SUDOC</a>: <span class="uid"><a rel="nofollow" class="external text" href="https://www.idref.fr/110886259">110886259</a></span></span></li>
                        <li><span class="nowrap"><a href="/wiki/TePapa_(identifier)" class="mw-redirect" title="TePapa (identifier)">TePapa</a>: <span class="uid"><a rel="nofollow" class="external text" href="https://collections.tepapa.govt.nz/agent/46293">46293</a></span></span></li>
                        <li><span class="nowrap"><a href="/wiki/VIAF_(identifier)" class="mw-redirect" title="VIAF (identifier)">VIAF</a>: <span class="uid"><a rel="nofollow" class="external text" href="https://viaf.org/viaf/124291214">124291214</a></span></span></li>
                        <li><span class="nowrap"> <a href="/wiki/WorldCat_Identities_(identifier)" class="mw-redirect" title="WorldCat Identities (identifier)">WorldCat Identities</a>: <a rel="nofollow" class="external text" href="https://www.worldcat.org/identities/lccn-no00095539">lccn-no00095539</a></span></li>
                     </ul>
                  </div>
               </td>
            </tr>
         </tbody>
      </table>
   </div>
</div>
''';

class HugeHtmlScreen extends StatelessWidget {
  const HugeHtmlScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('HugeHtmlScreen'),
          actions: const [PopupMenu()],
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text('renderMode: Column'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => _ColumnScreen()),
              ),
            ),
            ListTile(
              title: const Text('renderMode: ListView'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => _ListViewScreen()),
              ),
            ),
            ListTile(
              title: const Text('renderMode: SliverList'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => _SliverListScreen()),
              ),
            ),
          ],
        ),
      );
}

class _ColumnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('renderMode: Column')),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: RepaintBoundary(
              child: HtmlWidget(kHtml),
            ),
          ),
        ),
      );
}

class _ListViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('renderMode: ListView')),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: HtmlWidget(kHtml, renderMode: RenderMode.listView),
        ),
      );
}

class _SliverListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text('renderMode: SliverList'),
              floating: true,
              expandedHeight: 200,
              flexibleSpace: Placeholder(),
            ),
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: HtmlWidget(kHtml, renderMode: RenderMode.sliverList),
            ),
          ],
        ),
      );
}
