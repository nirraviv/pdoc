<%!
    # Template configuration
    html_lang = 'en'
    show_inherited_members = True
    list_class_variables_in_index = False
%>
<%
  import re

  import markdown

  import pdoc

  # Whether we're showing the module list or a single module.
  module_list = 'modules' in context.keys()

  def linkify(match, _is_pyident=re.compile(r'^[a-zA-Z_]\w*(\.\w+)+$').match):
    matched = match.group(0)
    refname = matched[1:-1]
    if not _is_pyident(refname):
        return matched
    dobj = module.find_ident(refname)
    return link(dobj, '<code>' + dobj.qualname + '</code>')

  def mark(s, linky=True):
    if linky:
      s, _ = re.subn('\b\n\b', ' ', s)
    if not module_list:
      s, _ = re.subn('`[^`]+`', linkify, s)

    extensions = []
    s = markdown.markdown(s.strip(), extensions=extensions)
    return s

  def glimpse(s, length=100):
    if len(s) < length:
      return s
    return s[0:length] + '...'

  def link(d, name=None, fmt='{}'):
    name = fmt.format(name or d.qualname + ('()' if isinstance(d, pdoc.Function) else ''))
    if not isinstance(d, pdoc.Doc) or isinstance(d, pdoc.External) and not external_links:
        return name
    if not show_inherited_members:
      d = d.inherits_top()
    return '<a href="{}">{}</a>'.format(d.url(relative_to=module, link_prefix=link_prefix), name)
%>

<%def name="ident(name)"><span class="ident">${name}</span></%def>

<%def name="show_source(d)">
    % if show_source_code and d.source and d.obj is not getattr(d.inherits, 'obj', None):
        <details class="source">
            <summary>Source code</summary>
            <pre><code class="python">${d.source | h}}</code></pre>
        </details>
    %endif
</%def>

<%def name="show_desc(d, limit=None)">
  <%
  inherits = (' class="inherited"'
              if d.inherits and (not d.docstring or d.docstring == d.inherits.docstring) else
              '')
  docstring = d.inherits.docstring if inherits else d.docstring
  if limit is not None:
    docstring = glimpse(docstring, limit)
  %>
  % if d.inherits:
      <p class="inheritance">
          <em>Inherited from:</em>
          % if hasattr(d.inherits, 'cls'):
              <code>${link(d.inherits.cls)}</code>.<code>${link(d.inherits, d.name)}</code>
          % else:
              <code>${link(d.inherits)}</code>
          % endif
      </p>
  % endif
  <div${inherits}>${docstring | mark}</div>
  % if not isinstance(d, pdoc.Module):
  ${show_source(d)}
  % endif
</%def>

<%def name="show_module_list(modules)">
<h1>Python module list</h1>

% if not modules:
  <p>No modules found.</p>
% else:
  <dl id="http-server-module-list">
  % for name, desc in modules:
      <div class="flex">
      <dt><a href="${link_prefix}${name}">${name}</a></dt>
      <dd>${desc | glimpse, mark}</dd>
      </div>
  % endfor
  </dl>
% endif
</%def>

<%def name="show_column_list(items)">
  <ul class="${'two-column' if len(items) >= 6 else ''}">
  % for item in items:
    <li><code>${link(item, item.name)}</code></li>
  % endfor
  </ul>
</%def>

<%def name="show_module(module)">
  <%
  variables = module.variables()
  classes = module.classes()
  functions = module.functions()
  submodules = module.submodules()
  %>

  <%def name="show_func(f)">
    <dt id="${f.refname}"><code class="name flex">
        <span>${f.funcdef()} ${ident(f.name)}</span>(<span>${', '.join(f.params()) | h})</span>
    </code></dt>
    <dd>${show_desc(f)}</dd>
  </%def>

  <header>
  % if 'http_server' in context.keys():
    <nav class="http-server-breadcrumbs">
      <a href="/">All packages</a>
      <% parts = module.name.split('.')[:-1] %>
      % for i, m in enumerate(parts):
        <% parent = '.'.join(parts[:i+1]) %>
        :: <a href="/${parent.replace('.', '/')}/">${parent}</a>
      % endfor
    </nav>
  % endif
  <h1 class="title"><code>${module.name}</code> module</h1>
  </header>

  <section id="section-intro">
  ${module.docstring | mark}
  ${show_source(module)}
  </section>

  <section>
    % if submodules:
    <h2 class="section-title" id="header-submodules">Sub-modules</h2>
    <dl>
    % for m in submodules:
      <dt><code class="name">${link(m)}</code></dt>
      <dd>${show_desc(m, limit=300)}</dd>
    % endfor
    </dl>
    % endif
  </section>

  <section>
    % if variables:
    <h2 class="section-title" id="header-variables">Global variables</h2>
    <dl>
    % for v in variables:
      <dt id="${v.refname}"><code class="name">var ${ident(v.name)}</code></dt>
      <dd>${show_desc(v)}</dd>
    % endfor
    </dl>
    % endif
  </section>

  <section>
    % if functions:
    <h2 class="section-title" id="header-functions">Functions</h2>
    <dl>
    % for f in functions:
      ${show_func(f)}
    % endfor
    </dl>
    % endif
  </section>

  <section>
    % if classes:
    <h2 class="section-title" id="header-classes">Classes</h2>
    <dl>
    % for c in classes:
      <%
      class_vars = c.class_variables(show_inherited_members)
      smethods = c.functions(show_inherited_members)
      inst_vars = c.instance_variables(show_inherited_members)
      methods = c.methods(show_inherited_members)
      mro = c.mro()
      subclasses = c.subclasses()
      %>
      <dt id="${c.refname}"><code class="flex name class">
          <span>class ${ident(c.name)}</span>
          % if mro:
              <span>(</span><span><small>ancestors:</small> ${', '.join(link(cls) for cls in mro)})</span>
          %endif
      </code></dt>

      <dd>${show_desc(c)}

      % if subclasses:
          <h3>Subclasses</h3>
          <ul class="hlist">
          % for sub in subclasses:
              <li>${link(sub)}</li>
          % endfor
          </ul>
      % endif
      % if class_vars:
          <h3>Class variables</h3>
          <dl>
          % for v in class_vars:
              <dt id="${v.refname}"><code class="name">var ${ident(v.name)}</code></dt>
              <dd>${show_desc(v)}</dd>
          % endfor
          </dl>
      % endif
      % if smethods:
          <h3>Static methods</h3>
          <dl>
          % for f in smethods:
              ${show_func(f)}
          % endfor
          </dl>
      % endif
      % if inst_vars:
          <h3>Instance variables</h3>
          <dl>
          % for v in inst_vars:
              <dt id="${v.refname}"><code class="name">var ${ident(v.name)}</code></dt>
              <dd>${show_desc(v)}</dd>
          % endfor
          </dl>
      % endif
      % if methods:
          <h3>Methods</h3>
          <dl>
          % for f in methods:
              ${show_func(f)}
          % endfor
          </dl>
      % endif
      </dd>
    % endfor
    </dl>
    % endif
  </section>
</%def>

<%def name="module_index(module)">
  <%
  variables = module.variables()
  classes = module.classes()
  functions = module.functions()
  submodules = module.submodules()
  supermodule = module.supermodule
  %>
  <nav id="sidebar">
    <h1>Index</h1>
    <ul id="index">
    % if supermodule:
    <li><h3>Super-module</h3>
      <ul>
        <li><code>${link(supermodule)}</code></li>
      </ul>
    </li>
    % endif

    % if submodules:
    <li><h3><a href="#header-submodules">Sub-modules</a></h3>
      <ul>
      % for m in submodules:
        <li><code>${link(m)}</code></li>
      % endfor
      </ul>
    </li>
    % endif

    % if variables:
    <li><h3><a href="#header-variables">Global variables</a></h3>
      ${show_column_list(variables)}
    </li>
    % endif

    % if functions:
    <li><h3><a href="#header-functions">Functions</a></h3>
      ${show_column_list(functions)}
    </li>
    % endif

    % if classes:
    <li><h3><a href="#header-classes">Classes</a></h3>
      <ul>
      % for c in classes:
        <li>
        <h4><code>${link(c)}</code></h4>
        <%
            members = c.functions() + c.methods()
            if list_class_variables_in_index:
                members += c.instance_variables() + c.class_variables()
            if not show_inherited_members:
                members = [i for i in members if not i.inherits]
            members = sorted(members)
        %>
        % if members:
          ${show_column_list(members)}
        % endif
        </li>
      % endfor
      </ul>
    </li>
    % endif

    </ul>
  </nav>
</%def>

<!doctype html>
<html lang="${html_lang}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1" />
  <meta name="generator" content="pdoc ${pdoc.__version__}" />

  % if module_list:
    <title>Python module list</title>
    <meta name="description" content="A list of documented Python modules." />
  % else:
    <title>${module.name} API documentation</title>
    <meta name="description" content="${module.docstring | glimpse, trim, h}" />
  % endif

  <link href='https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.0/normalize.min.css' rel='stylesheet'>
  <link href='https://cdnjs.cloudflare.com/ajax/libs/10up-sanitize.css/8.0.0/sanitize.min.css' rel='stylesheet'>
  % if show_source_code:
    <link href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/github.min.css" rel="stylesheet">
  %endif

  <%namespace name="css" file="css.mako" />
  <style>${css.mobile()}</style>
  <style media="screen and (min-width: 700px)">${css.desktop()}</style>
  <style media="print">${css.print()}</style>

</head>
<body>
<main>
  % if module_list:
    <article id="content">
      ${show_module_list(modules)}
    </article>
  % else:
    <article id="content">
      ${show_module(module)}
    </article>
    ${module_index(module)}
  % endif
</main>

<footer id="footer">
    <p>Generated by <a href="https://github.com/mitmproxy/pdoc">pdoc ${pdoc.__version__}</a></p>
</footer>

% if show_source_code:
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js"></script>
    <script>hljs.initHighlightingOnLoad()</script>
% endif
</body>
</html>
