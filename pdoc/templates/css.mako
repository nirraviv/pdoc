<%!
    from pdoc.html_helpers import minify_css
%>

<%def name="mobile()" filter="minify_css">
  .flex {
    display: flex !important;
  }

  body {
    line-height: 1.5em;
  }

  #content {
    padding: 20px;
  }

  #sidebar {
    padding: 30px;
    overflow: hidden;
  }

  .http-server-breadcrumbs {
    font-size: 130%;
    margin: 0 0 15px 0;
  }

  #footer {
    font-size: .75em;
    padding: 5px 30px;
    border-top: 1px solid #ddd;
    text-align: right;
  }
    #footer p {
      margin: 0 0 0 1em;
      display: inline-block;
    }
    #footer p:last-child {
      margin-right: 30px;
    }

  h1, h2, h3, h4, h5 {
    font-weight: 300;
  }
  h1 {
    font-size: 2.5em;
    line-height: 1.1em;
  }
  h2 {
    font-size: 1.75em;
    margin: 1em 0 .50em 0;
  }
  h3 {
    margin: 25px 0 10px 0;
  }
  h4 {
    margin: 0;
    font-size: 105%;
  }

  a {
    color: #058;
    text-decoration: none;
    transition: color .3s ease-in-out;
  }
  a:hover {
    color: #e82;
  }

  .title code {
    font-weight: bold;
  }
  h2[id=^header-] {
    margin-top: 2em;
  }
  .ident {
    color: #900;
  }

  pre code {
    background: #f8f8f8;
    font-size: .8em;
    line-height: 1.4em;
  }
  code {
    background: #f2f2f1;
    padding: 1px 4px;
    overflow-wrap: break-word;
  }
  h1 code { background: transparent }

  pre {
    background: #f8f8f8;
    border: 1px solid #ddd;
    margin: 1em 0 1em 4ch;
  }

  #http-server-module-list {
    display: flex;
    flex-flow: column;
  }
    #http-server-module-list div {
      display: flex;
    }
    #http-server-module-list dt {
      min-width: 10%;
    }
    #http-server-module-list p {
      margin-top: 0;
    }

  .toc ul,
  #index {
    list-style-type: none;
    margin: 0;
    padding: 0;
  }
    #index code {
      background: transparent;
    }
    #index h3 {
      border-bottom: 1px solid #ddd;
    }
    #index ul {
      padding: 0;
    }
    #index h4 {
      font-weight: bold;
    }
    #index h4 + ul {
      margin-bottom:.6em;
    }
    #index .two-column {
      column-count: 2;
    }

  dl {
    margin-bottom: 2em;
  }
    dl dl:last-child {
      margin-bottom: 4em;
    }
  dd {
    margin: 0 0 1em 3em;
  }
    #header-classes + dl > dd {
      margin-bottom: 3em;
    }
    dd dd {
      margin-left: 2em;
    }
    dd p {
      margin: 10px 0;
    }
    .name {
      background: #eee;
      font-weight: bold;
      font-size: .85em;
      padding: 5px 10px;
      display: inline-block;
      min-width: 40%;
    }
      .name:hover {
        background: #e0e0e0;
      }
      .name > span:first-child {
        white-space: nowrap;
      }
      .name.class > span:nth-child(2) {
        margin-left: .4em;
      }
      .name small {
        font-weight: normal;
      }
    .inherited {
      color: #999;
      border-left: 5px solid #eee;
      padding-left: 1em;
    }
    .inheritance em {
      font-style: normal;
      font-weight: bold;
    }

    .source summary {
      background: #ffc;
      font-weight: 400;
      font-size: .8em;
      width: 11em;
      text-transform: uppercase;
      padding: 0px 8px;
      border: 1px solid #fd6;
      border-radius: 5px;
      cursor: pointer;
    }
      .source summary:hover {
        background: #fe9 !important;
      }
      .source[open] summary {
        background: #fda;
      }
    .source pre {
      max-height: 500px;
      overflow-y: scroll;
      margin-bottom: 15px;
    }
  .hlist {
    list-syle: none;
  }
    .hlist li {
      display: inline;
    }
    .hlist li:after {
      content: ',\2002';
    }
    .hlist li:last-child:after {
      content: none;
    }
</%def>

<%def name="desktop()" filter="minify_css">
  @media screen and (min-width: 700px) {
    #sidebar {
      width: 30%;
    }
    #content {
      width: 70%;
      max-width: 100ch;
      padding: 3em 4em;
      border-left: 1px solid #ddd;
    }
    pre code {
      font-size: 1em;
    }
    .item .name {
      font-size: 1em;
    }
    main {
      display: flex;
      flex-direction: row-reverse;
      justify-content: flex-end;
    }
    .toc ul ul,
    #index ul {
      padding-left: 1.5em;
    }
    .toc > ul > li {
      margin-top: .5em;
    }
  }
</%def>

<%def name="print()" filter="minify_css">
@media print {
  #sidebar h1 {
    page-break-before: always;
  }
  .source {
    display: none;
  }
}
@media print {
    * {
        background: transparent !important;
        color: #000 !important; /* Black prints faster: h5bp.com/s */
        box-shadow: none !important;
        text-shadow: none !important;
    }

    a,
    a:visited {
        text-decoration: underline;
    }

    a[href]:after {
        content: " (" attr(href) ")";
    }

    abbr[title]:after {
        content: " (" attr(title) ")";
    }

    /*
     * Don't show links for images, or javascript/internal links
     */

    .ir a:after,
    a[href^="javascript:"]:after,
    a[href^="#"]:after {
        content: "";
    }

    pre,
    blockquote {
        border: 1px solid #999;
        page-break-inside: avoid;
    }

    thead {
        display: table-header-group; /* h5bp.com/t */
    }

    tr,
    img {
        page-break-inside: avoid;
    }

    img {
        max-width: 100% !important;
    }

    @page {
        margin: 0.5cm;
    }

    p,
    h2,
    h3 {
        orphans: 3;
        widows: 3;
    }

    h1,
    h2,
    h3,
    h4,
    h5,
    h6 {
        page-break-after: avoid;
    }
}
</%def>
