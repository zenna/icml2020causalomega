using ParserCombinator

using ParserCombinator
import Base.==

reader_table = Dict{Symbol, Function}()

expr         = Delayed()
floaty_dot   = p"[-+]?[0-9]*\.[0-9]+([eE][-+]?[0-9]+)?[Ff]" > (x -> parse(Float32, x[1:end-1]))
floaty_nodot = p"[-+]?[0-9]*[0-9]+([eE][-+]?[0-9]+)?[Ff]" > (x -> parse(Float32, x[1:end-1]))
floaty       = floaty_dot | floaty_nodot
white_space  = p"([\s\n\r]*(?<!\\);[^\n\r$]+[\n\r\s$]*|[\s\n\r]+)"
opt_ws       = white_space | e""

doubley      = p"[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?[dD]" > (x -> parse(Float64, x[1:end-1]))

inty         = p"[-+]?\d+" > (x -> parse(Int, x))

uchary       = p"\\(u[\da-fA-F]{4})" > (x -> first(unescape_string(x)))
achary       = p"\\[0-7]{3}" > (x -> unescape_string(x)[1])
chary        = p"\\." > (x -> x[2])

stringy      = p"(?<!\\)\".*?(?<!\\)\"" > (x -> x[2:end-1]) #_0[2:end-1] } #r"(?<!\\)\".*?(?<!\\)"
booly        = p"(true|false)" > (x -> x == "true" ? true : false)
symboly      = p"[^\d(){}#'`,@~;~\[\]^\s][^\s()#'`,@~;^{}~\[\]]*" > Symbol
macrosymy    = p"@[^\d(){}#'`,@~;~\[\]^\s][^\s()#'`,@~;^{}~\[\]]*" > Symbol

sexpr        = E"(" + ~opt_ws + Repeat(expr + ~opt_ws) + E")" |> (x -> s_expr(x))
hashy        = E"#{" + ~opt_ws + Repeat(expr + ~opt_ws) + E"}" |> (x -> Set(x))
curly        = E"{" + ~opt_ws + Repeat(expr + ~opt_ws) + E"}" |> (x -> Dict(x[i] => x[i+1] for i = 1:2:length(x)))
dispatchy    = E"#" + symboly + ~opt_ws + expr |> (x -> reader_table[x[1]](x[2]))
bracket      = E"[" + ~opt_ws + Repeat(expr + ~opt_ws) + E"]" |> (x -> s_expr(x)) # TODO: not quite right
quot         = E"'" + expr > (x -> sx(:quote, x))
quasi        = E"`" + expr > (x -> sx(:quasi, x))
tildeseq     = E"~@" + expr > (x -> sx(:splice_seq, x))
tilde        = E"~" + expr > (x -> sx(:splice, x))

expr.matcher = doubley | floaty | inty | uchary | achary | chary | stringy | booly | symboly |
               macrosymy | dispatchy | sexpr | hashy | curly | bracket |
               quot | quasi | tildeseq | tilde

top_level    = Repeat(~opt_ws + expr) + ~opt_ws + Eos()

"Parse `str` into `OExpr`"
function parseomega(str)
  x = parse_one(str, expr)
  x[1]
end