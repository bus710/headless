#[[https://blog.kitware.com/cmake-building-with-all-your-cores/]]
#[[For Makefile "cmake CMakeLists.txt" to generate Makefile]]
#[[For Ninja:
- cd ..
- mkdir build
- cd build
- cmake -GNinja ../src
- ninja
]]

ADD_EXECUTABLE( main main.c )
