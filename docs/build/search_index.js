var documenterSearchIndex = {"docs":
[{"location":"benchmark_case/#Benchmark-cases","page":"Benchmark cases","title":"Benchmark cases","text":"","category":"section"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"In this example, we will use FreeRay to model 4 benchmark cases for outdoor sound propagation as published by Attenborough et al. (1995).","category":"page"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"There is an unit point source at h_s = 50 m, a receiver at h_r = 10 m and at a horizontal range R=10000 m. The source emits a constant tone of f = 100 Hz.","category":"page"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"The ground surface is treated as an impedance boundary with the specific characteristic impedance Z_c = 1281 + i1162. This value is used to calculate spherical-wave reflection coefficients.","category":"page"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"The differences between 4 benchmark cases are the use of different sound speed profiles such as constant, positive, negative and composite profiles.","category":"page"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"Ref: Attenborough, Keith, et al. \"Benchmark cases for outdoor sound propagation models.\" The Journal of the Acoustical Society of America 97.1 (1995): 173-191.","category":"page"},{"location":"benchmark_case/#Case-1:-Constant-sound-speed-profile","page":"Benchmark cases","title":"Case 1: Constant sound speed profile","text":"","category":"section"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"Load FreeRay package","category":"page"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"using FreeRay","category":"page"},{"location":"benchmark_case/#Source","page":"Benchmark cases","title":"Source","text":"","category":"section"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"We may notice that the source height is inputted as a negative number. This is convention of Bellhop where upper and lower spaces are modelled as negative and positive axis, respectively. We are interested in upper space, so hereafter all input values for height are negative numbers.","category":"page"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"source = Source(\r\n        frequency = 100f0, # Hz, f0 indicate Float32 number.\r\n        height = -5f0) # m, height","category":"page"},{"location":"benchmark_case/#Receiver","page":"Benchmark cases","title":"Receiver","text":"","category":"section"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"In the benchmark case, only receiver at 1.0 m is interested, but to plot the transmission loss field, we here will calculate for every grid points spacing 1.0 m in both vertical and horizontal directions. The investigation region is 1,000 m in height and 10,000 m in range. Obviously, this will cover the configuration of the benchmark case!","category":"page"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"receiver = Receiver(\r\n        depth_point = 1001, # number of points in height\r\n        range_point = 10001, # number of points in range\r\n        depth = Vec2(-1000f0,0f0), # height between -1000 m and 0\r\n        range = Vec2(0f0,10f0)) # range between 0 and 10 km (range is always in km)","category":"page"},{"location":"benchmark_case/#Terrain-geometry","page":"Benchmark cases","title":"Terrain geometry","text":"","category":"section"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"We assume that the ground elevation is flat for now, real ground elevation will be discussed in other examples.","category":"page"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"terrain = Terrain(\r\n    interp_type = \"C\", # interpolation method for ground elevation\r\n    profile = (Vec2([0f0,5f0,10f0],[0f0,0f0,0f0])) # need 3 points for modelling flat terrain\r\n)","category":"page"},{"location":"benchmark_case/#Boundary-condition","page":"Benchmark cases","title":"Boundary condition","text":"","category":"section"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"The ground surface is modelled using reflection coefficients which are calculated from characteristic ground impedance Z_c. We may not show calculation details in here, but this can be calculated using Q_reflection function. The top boundary is atmospheric, thus can be modelled as \"no reflection\". In other words, the reflection coefficients are zero.","category":"page"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"\r\n# Vec3(grazing angle, coefficient, phase angle)\r\nbrc = Vec3([0f0,45f0,90f0],[1f0,1f0,1f0],[0f0,0f0,0f0])\r\ntrc = Vec3([0f0,45f0,90f0],[0f0,0f0,0f0],[0f0,0f0,0f0])\r\n\r\nreflection = Reflection_Coeff(\r\n    top_coeff = trc,\r\n    bottom_coeff = brc)","category":"page"},{"location":"benchmark_case/#Sound-speed-profile","page":"Benchmark cases","title":"Sound speed profile","text":"","category":"section"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"In this case, we have sound speed is constant c_0 = 343 m/s.","category":"page"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"# Vec2 (height, sound speed)\r\nsspl = Vec2([-1000f0,-500f0,0f0],[343f0,343f0,343f0])\r\nssp = SSP(sound_speed_profile = sspl)","category":"page"},{"location":"benchmark_case/#Analysis","page":"Benchmark cases","title":"Analysis","text":"","category":"section"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"This is an important part to specify what analysis we want to run. To just analyse ray tracing, the option is analyse = \"R\". To analyse acoustic fields, we need to use following options:","category":"page"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"analyse = \"CG\" - coherent geometric ray model\nanalyse = \"IG\" - incoherent geometric ray model\nanalyse = \"CB\" - coherent Gaussian ray model\nanalyse = \"IB\" - incoherent Gaussian ray model","category":"page"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"opt = Analysis(\r\n    filename = \"Case0_Bellhop_f10\", # name of output files\r\n    analyse = \"RG\", # analysis options C-coherent, I-incoherent, G-Geometric ray, B- Gaussian ray.\r\n    option1 = \"CFW\",\r\n    option2 = \"F*\",\r\n    num_ray = 161, # number of ray, resulting in resolution of take-off angles\r\n    alpha = Vec2(-80.0f0,80.0f0), # take-off angle from -80 to 80\r\n    box = Vec2(10f0,1000.0f0),\r\n    step= 0\r\n)","category":"page"},{"location":"benchmark_case/#Create-input-files","page":"Benchmark cases","title":"Create input files","text":"","category":"section"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"Environment(opt,source, receiver,ssp,terrain,reflection)","category":"page"},{"location":"benchmark_case/#Run-Bellhop","page":"Benchmark cases","title":"Run Bellhop","text":"","category":"section"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"fn= opt.filename\r\nfilename = \"temp\\\\$fn\"\r\nrun_bellhop = `bellhop $filename`\r\n@time run(run_bellhop)","category":"page"},{"location":"benchmark_case/#Plots","page":"Benchmark cases","title":"Plots","text":"","category":"section"},{"location":"benchmark_case/","page":"Benchmark cases","title":"Benchmark cases","text":"PlotRay(\"$filename.ray\",\r\n        xlabs = \"Range, m\",\r\n        ylabs = \"Height, m\")\r\n\r\np = PlotShd(\"$filename.shd\";\r\n        xlabs = \"Range, m\",\r\n        ylabs = \"Transmission loss, dB\",\r\n        cblabs = \"dB\",\r\n        climb = (40,80))\r\nsavefig(p,\"plot.png\")\r\n\r\nPlotTlr(\"$filename.shd\", -50;\r\n        xlabs = \"Range, m\",\r\n        ylabs = \"Transmission loss, dB\",\r\n        xlim = (0,10000),\r\n        ylim = (20,120))","category":"page"},{"location":"benchmark_case/#Case-2","page":"Benchmark cases","title":"Case 2","text":"","category":"section"},{"location":"benchmark_case/#Case-3","page":"Benchmark cases","title":"Case 3","text":"","category":"section"},{"location":"benchmark_case/#Case-4","page":"Benchmark cases","title":"Case 4","text":"","category":"section"},{"location":"#FreeRay-:-Bellhop-for-Outdoor-Sound-Propagation","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"","category":"section"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"<p align=\"center\">\r\n    <img width=500 height=400 src=\"../../plot.PNG\">\r\n</p>","category":"page"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"FreeRay.jl is a library for outdoor noise propagation. Numerical ray tracing models are implemented using Bellhop ray tracing program written in Fortran by Michael Porter. FreeRay.jl provides utilities for","category":"page"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"Prepare input files, run Bellhop and plot output.\nRun Bellhop parallel.","category":"page"},{"location":"#Installation","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"Installation","text":"","category":"section"},{"location":"#FreeRay.jl-package","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay.jl package","text":"","category":"section"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"Download Julia 1.5 or later.","category":"page"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"FreeRay.jl is under development and thus is not registered. To install it simply open a julia REPL and do","category":"page"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"`] add https://github.com/ducphucnguyen/FreeRay.jl.git`.","category":"page"},{"location":"#Installation-Bellhop","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"Installation Bellhop","text":"","category":"section"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"Before we can use FreeRay, we need to install Bellhop first. The source code can be download from this website Bellhop. installation details are provided in the website. If you have no experience with programming languages such as C or Fortran, it will take sometime to install Bellhop!","category":"page"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"To check if Bellhop is successfully installed, we run this command in Julia REPL. If we can see the bellow error, this means that we successfully install Bellhop.  Congratulation!","category":"page"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"run(`bellhop`)\r\n\r\nSTOP Fatal Error: Check the print file for details\r\nProcess(`bellhop`, ProcessExited(0))","category":"page"},{"location":"#Supporting-and-Citing","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"Supporting and Citing","text":"","category":"section"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"This software was developed as part of academic research. If you would like to help support it, please star the repository. If you use this software as part of your research, teaching, or other activities, we would be grateful if you could cite:","category":"page"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"@article{nguyen2020machine,\r\n  title={A machine learning approach for detecting wind farm noise amplitude modulation},\r\n  author={Nguyen, Duc Phuc and Hansen, Kristy and Lechat, Bastien and Catcheside, Peter and Zajamsek, Branko},\r\n  year={2020},\r\n  publisher={Preprints}\r\n}","category":"page"},{"location":"#Contribution-Guidelines","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"Contribution Guidelines","text":"","category":"section"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"This package is written and maintained by Duc Phuc Nguyen. Please fork and send a pull request or create a GitHub issue for bug reports. If you are submitting a pull request make sure to follow the official Julia Style Guide and please use 4 spaces and NOT tabs.","category":"page"},{"location":"#Contents","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"Contents","text":"","category":"section"},{"location":"#Home","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"Home","text":"","category":"section"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"Pages = [\r\n    \"index.md\"\r\n]\r\nDepth = 2","category":"page"},{"location":"#Getting-Started-Tutorials","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"Getting Started Tutorials","text":"","category":"section"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"Pages = [\r\n    \"benchmark_case.md\",\r\n    \"getting_started/inverse_lighting.md\",\r\n    \"getting_started/optim_compatibility.md\"\r\n]\r\nDepth = 2","category":"page"},{"location":"#API-Documentation","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"API Documentation","text":"","category":"section"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"Pages = [\r\n    \"api/utilities.md\",\r\n    \"api/differentiation.md\",\r\n    \"api/scene.md\",\r\n    \"api/optimization.md\",\r\n    \"api/renderers.md\",\r\n    \"api/accelerators.md\"\r\n]\r\nDepth = 2","category":"page"},{"location":"#Index","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"Index","text":"","category":"section"},{"location":"","page":"FreeRay : Bellhop for Outdoor Sound Propagation","title":"FreeRay : Bellhop for Outdoor Sound Propagation","text":"","category":"page"}]
}
