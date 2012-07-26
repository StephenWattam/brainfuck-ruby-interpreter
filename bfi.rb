#!/usr/bin/ruby

# Machine
$cells = []
$instructions = []

# Load data
def read_instructions(filename)
  f = File.open(filename) 
  c = f.getc
  while(c)
    $instructions << c if "<>+-[],.".include?(c)
    c = f.getc
  end
  f.close
end

# Seek an end-bracket
def scan(dir, s, e, ip)
  dep = 1
  ip += dir
  
  while(dep > 0)
    ip += dir
    dep += 1 if($instructions[ip] == s)
    dep -= 1 if($instructions[ip] == e)
  end
  
  return ip
end

# Provide a default cell value, for infinite tape.
def dcell(i)
  return 0 if not $cells[i]
  return $cells[i]  
end

# Run the thingy
def run_bf
  dp = 0
  ip = 0
  
  while(ip >= 0 and ip < $instructions.length)


    case($instructions[ip])
      when '>' 
        dp += 1
      when '<' 
        dp -= 1
      when '+' 
        $cells[dp] = dcell(dp) + 1
      when '-' 
        $cells[dp] = dcell(dp) - 1
      when '.' 
        print dcell(dp).chr
      when ',' 
        $cells[dp] = bf_input 
      when ']' 
        ip = scan(-1, ']', '[', ip) if dcell(dp) != 0
      when '[' 
        ip = scan( 1, '[', ']', ip) if dcell(dp) == 0
    end

    ip += 1
  end
end

# brainfuck input device#
def bf_input
    input = nil
    while(not input) do
      input = $stdin.getc
    end
    return input.chr.ord
end

read_instructions(ARGV[0])
run_bf
