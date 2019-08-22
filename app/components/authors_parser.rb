class AuthorsParser < Parslet::Parser
  rule(:space)    { match['\s'].repeat }

  rule(:lbracket) { str('[') }
  rule(:rbracket) { str(']') }
  rule(:lt)       { space >> str('<') }
  rule(:gt)       { str('>') }

  rule(:lparen)   { space >> str('(') }
  rule(:rparen)   { str(')') }

  rule(:comma)    { (str(',') | (space >> str('and')) | (space >> str('&'))) >> space  }
  rule(:dot)      { str('.') }

  #rule(:word)     { match(/[-[:alnum:]]|\.|\'/u).repeat(1) }
  rule(:word)     { ((lbracket | lt | lparen | str(',') | str('&') | str('and') | match(/\s/)).absent? >> any).repeat(1) }
  rule(:nickname) { lparen >> (rparen.absent? >> any).repeat(1) >> rparen }
  rule(:name)     { (word >> nickname.maybe >> (space >> word).repeat).as(:name) >> space }
  rule(:role)     { lbracket >> (rbracket.absent? >> any).repeat(1).as(:role) >> rbracket }

  rule(:email)    { lt >> (gt.absent? >> any).repeat(1).as(:email) >> gt }
  rule(:url)      { lparen >> lt >> (str('>)').absent? >> any).repeat(1).as(:url) >> gt >> rparen }
  rule(:comment)  { lparen >> (rparen.absent? >> any).repeat(1).as(:comment) >> rparen }

  rule(:author)   { name >> role.maybe >> email.maybe >> url.maybe >> comment.maybe }
  rule(:authors)  { author >> (comma >> author).repeat >> dot.maybe }

  root :authors
end

