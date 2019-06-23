class AuthorsParser < Parslet::Parser
  rule(:space?)   { match('\s').maybe }

  rule(:lbracket) { space? >> str('[') }
  rule(:rbracket) { str(']') >> space? }
  rule(:lt)       { space? >> str('<') }
  rule(:gt)       { str('>') >> space? }

  rule(:comma)    { str(',') | str('and') }

  rule(:name)     { ((str('<') | str('[') | str(',') | str('and')).absent? >> any).repeat.as(:name) }
  rule(:email)    { (str('>').absent? >> any).repeat.as(:email) }
  rule(:role)     { (str(']').absent? >> any).repeat.as(:role) }
  rule(:author)   { name >> (lt >> email >> gt).maybe >> (lbracket >> role >> rbracket).maybe }
  rule(:authors)  { author >> (comma >> author).repeat }

  root :authors
end


