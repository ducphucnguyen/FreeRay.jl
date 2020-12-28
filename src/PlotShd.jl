
filename = "Case0_Bellhop_f10.shd"
recl = Array{Int32}(undef, 1, 1)

 #read!(filename, recl)

io = open(filename,"r")


#open(filename) do file
recl = read(io, Int32)

for i=1:80
        println(read(io, Char))
end

#end


seekstart(io)
seek(io, 4*recl)

for i=1:10
        println(read(io, Char))
end

seekstart(io)
seek(io, 2*4*recl)


println(read(io, Int32))


#position(io)

#seekend(io)






#skip(io, 10);
