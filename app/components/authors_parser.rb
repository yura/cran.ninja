class AuthorsParser < Parslet::Parser
  rule(:space?)   { match('\s').maybe }

  rule(:lbracket) { space? >> str('[') }
  rule(:rbracket) { str(']') >> space? }
  rule(:lt)       { space? >> str('<') }
  rule(:gt)       { str('>') >> space? }
  rule(:lparen)   { str('(') }
  rule(:rparen)   { str(')') >> space? }

  rule(:comma)    { str(',') | str('and') }

  rule(:name)     { ((lbracket | lt | lparen | comma).absent? >> any).repeat.as(:name) }
  rule(:email)    { (str('>').absent? >> any).repeat.as(:email) }
  rule(:role)     { (str(']').absent? >> any).repeat.as(:role) }
  rule(:url)      { (str('>)').absent? >> any).repeat.as(:url) }
  rule(:university) { (str(')').absent? >> any).repeat.as(:university) }
  rule(:author)   { name >> (lt >> email >> gt).maybe >> (lbracket >> role >> rbracket).maybe >> (lparen >> lt >> url >> gt >> rparen).maybe >> (lparen >> university >> rparen).maybe }
  rule(:authors)  { author >> (comma >> author).repeat }

  root :authors
end

