class AuthorsParser < Parslet::Parser
  rule(:lbracket) { space? >> str('[') >> space? }
  rule(:rbracket) { str(']') >> space? }
  rule(:lt)       { space? >> str('<') >> space? }
  rule(:gt)       { str('>') >> space? }

  rule(:comma)    { str(',') >> space? }
  rule(:space?)   { str('\s').repeat }

  rule(:name)     { match('[^,\[<]').repeat.as(:name)}
  rule(:email)    { match('[^>]').repeat.as(:email)}
  rule(:role)     { match('[^\]]').repeat.as(:role) }
  rule(:author)   { name >> (lt >> email >> gt).maybe >> (lbracket >> role >> rbracket).maybe }
  rule(:authors)  { author >> (comma >> author).repeat }
  root :authors
end


