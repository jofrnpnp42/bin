#!/usr/bin/env ruby
# Usage: ./2to1.rb [command [args...]]
# エラー出力を標準出力に繋ぐプログラム
# http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-list/37344 から一部追加した

def quote_shell(unquoted)
    quoted = unquoted.dup
    # \ -> \\
    quoted.gsub! %r"\\" do '\\\\' end
    # " -> \"
    quoted.gsub! %r'"' do '\\"' end
    # ` -> \`
    quoted.gsub! %r'`' do '\\`' end
    # $ -> \$
    quoted.gsub! %r'\$' do '\\$' end
    # newline -> \newline
    quoted.gsub! %r'\n' do "\\\n" end
    # ' ' -> '\ '
    quoted.gsub! %r' ' do '\ ' end
    quoted
end

# コマンドラインを一つの文字列にする(配列の連結)
def copy_cmdline(*args)
    tmp = ""
    args.each {|i|
        tmp << quote_shell(i) + " "
    }
    return tmp
end

STDERR.reopen(STDOUT)
cmd = copy_cmdline(*ARGV)
system(cmd)

