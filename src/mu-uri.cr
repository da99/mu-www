
require "uri"
require "html"

module Mu_URI

  VALID_FRAGMENT  = /^[a-zA-Z0-9\_\-]+$/
  BEGINNING_SLASH = /^\//
  CNTRL_CHARS     = /[[:cntrl:]]+/i
  WHITE_SPACE     = /[\s[:cntrl:]]+/i
  FIND_A_DOT      = /\./
  FIND_A_SLASH    = /\//
  PATH_HAS_A_HOST = /^[^\/]+\/?/

  extend self

  def unescape(raw : String)
    old_s = ""
    new_s = raw
    while old_s != new_s
      old_s = new_s
      new_s = HTML.unescape(new_s)
    end
    new_s
  end # === def unescape

  def set_default_host(u : URI)
    return u unless is_empty?(u.host)
    return u if is_empty?(u.path)
    path = u.path
    case path
    when String
      crumbs = path.split("/")
      return u if crumbs.empty?
      return u if is_empty?(crumbs.first) # /some/path
      new_host = crumbs.first
      crumbs[0] = ""
      u.host = new_host
      u.path = crumbs.join("/")
      u.path = nil if is_empty?(u.path)
    end
    u
  end # === def set_default_host

  def set_default_scheme(n : Nil)
    nil
  end # === def set_default_scheme

  def set_default_scheme(u : URI)
    if !u.scheme
      if !is_empty?(u.host)
        u.scheme = "http"
      end
    end
    u
  end # === def set_default_scheme

  def require_slash_for_relative_urls(u : URI)
    if !u.scheme && is_empty?(u.host) && (u.path.is_a?(String) && u.path !~ BEGINNING_SLASH)
      return nil
    end
    u
  end # === def slash_for_relative_urls

  def is_fragment_only?(u : URI)
    u.fragment && !u.host && !u.query && !u.path
  end

  def clean_fragment(s : String)
    s = s.strip
    return nil unless s =~ VALID_FRAGMENT
    s
  end # === def clean_fragment

  def clean_fragment(n : Nil)
    nil
  end

  def clean_fragment(u : URI)
    u.fragment = clean_fragment(u.fragment)
    u
  end # === def clean_fragment

  def is_allowed_scheme?(s : String)
    case s
    when "http", "https", "ftp", "sftp", "git", "ssh", "svn"
      return true
    end
    false
  end

  def clean_scheme(n : Nil)
    nil
  end # === def clean_scheme

  def clean_scheme(s : String)
    s = URI.unescape(s)
    return s if is_allowed_scheme?(s)

    new_s = URI.unescape(s.downcase.strip)
    return new_s if is_allowed_scheme?(new_s)
    nil
  end

  def clean_scheme(u : URI)
    sch = u.scheme
    case sch
    when String
      u.scheme = (clean_scheme(sch) || clean_scheme(sch.downcase.strip))
    else
      u.scheme = clean_scheme(sch)
    end

    u
  end

  def normalize(n : Nil)
    nil
  end # === def normalize

  def is_empty?(n : Nil)
    true
  end # === def is_empty?

  def is_empty?(s : String)
    s.strip.empty?
  end # === def is_empty?

  def normalize(u : URI)
    fin = u.normalize.to_s.strip
    return nil if fin == ""
    return nil if is_empty?(u.host) && is_empty?(u.path) && is_empty?(u.fragment)
    HTML.escape(escape_non_ascii(fin))
  end # === def normalize

  def clean_cntrl_chars(s : String)
    return nil if s =~ CNTRL_CHARS
    s
  end # === def clean_cntrl_chars

  def escape_non_ascii(s : String)
    s.gsub( /[^[:ascii:]]+/ ) do | str |
      URI.escape(str)
    end
  end # === def escape_non_ascii

  def clean_host(s : String)
    return nil if s =~ WHITE_SPACE
    return nil if s.empty?

    decoded = URI.unescape(s)
    return nil if decoded != s

    escape_non_ascii(s)
  end # === def clean_host

  def clean_host(u : URI)
    s = u.host
    case s
    when String
      new_host = clean_host(s)
      return nil unless new_host
      u.host = new_host
    end
    return u
  end # === def clean_host

  def clean_path(s : String)
    return nil if is_empty?(s)
    new_s = s.strip
    decoded = URI.unescape(new_s)
    return nil if decoded != new_s
    new_s
  end # === def clean_path

  def clean_path(n : Nil)
    nil
  end # === def clean_path

  def clean_path(u : URI)
    new_p = clean_path(u.path)
    u.path = new_p
    u
  end # === def clean_path

  def clean_user(u : URI)
    u.user = nil
    u
  end # === def clean_user

  def clean_password(u : URI)
    u.password = nil
    u
  end # === def clean_password

  def clean_opaque(u : URI)
    o = u.opaque
    return nil unless is_empty?(o)
    u
  end # === def clean_opaque

  def inspect_uri(n : Nil)
    puts n.inspect
  end

  def inspect_uri(s : String)
    inspect_uri(URI.parse(s))
  end # === def inspect_uri

  def inspect_uri(uri : URI)
    puts uri.to_s
    {% for id in ["scheme", "opaque", "user", "password", "host", "path", "query", "fragment"] %}
      spaces = " " * (15 - "{{id.id}}".size)
      puts "{{id.id}}:#{spaces}#{uri.{{id.id}}.inspect}"
    {% end %}
    puts uri.normalize.to_s
    puts ""
  end # === def inspect_uri

  def escape(raw : String)
    if raw.match(/\n/)
      puts (raw).inspect
      puts("i: " + (raw =~ /[[:cntrl:]]/).inspect)
    end

    raw = unescape(raw.strip)
    raw = clean_cntrl_chars(raw)
    return nil unless raw

    u = URI.parse(raw)

    origin_scheme = u.scheme

    u = set_default_host(u)
    {% for meth in "scheme user password opaque fragment host path".split  %}
      if u
        u = clean_{{meth.id}}(u)
        return nil unless u
      end
    {% end %}

    # If the scheme disappeared, that means the entire
    # URL was invalid to begin with. Return nil to be
    # safe.
    return nil if origin_scheme && !u.scheme
    u = set_default_scheme(u)
    u = require_slash_for_relative_urls(u)
    normalize(u)
  end # === def escape
end # === module Mu_URI
