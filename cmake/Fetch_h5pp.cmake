set(EIGEN3_NO_CMAKE_PACKAGE_REGISTRY TRUE)
set(SPDLOG_NO_CMAKE_PACKAGE_REGISTRY TRUE)
find_package(h5pp 1.1.0 HINTS ${CMAKE_INSTALL_PREFIX} ${CONDA_HINTS} PATHS ${CMAKE_INSTALL_PREFIX}   PATH_SUFFIXES h5pp)

if(h5pp_FOUND AND TARGET h5pp::h5pp)
    message(STATUS "h5pp found")
elseif(DOWNLOAD_METHOD MATCHES "native")
    message(STATUS "h5pp will be installed into ${CMAKE_INSTALL_PREFIX}")
    include(${PROJECT_SOURCE_DIR}/cmake/BuildDependency.cmake)
    get_target_property(EIGEN3_INCLUDE_DIR Eigen3::Eigen INTERFACE_INCLUDE_DIRECTORIES)
    list(APPEND H5PP_CMAKE_OPTIONS  -DEigen3_DIR:PATH=${CMAKE_INSTALL_PREFIX}/Eigen3)
    list(APPEND H5PP_CMAKE_OPTIONS  -DEIGEN3_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/Eigen3/include/eigen3)
    list(APPEND H5PP_CMAKE_OPTIONS  -DH5PP_DIRECTORY_HINTS:PATH=${CMAKE_INSTALL_PREFIX})
    list(APPEND H5PP_CMAKE_OPTIONS  -DDOWNLOAD_METHOD:BOOL=${DOWNLOAD_METHOD})
    list(APPEND H5PP_CMAKE_OPTIONS  -DPREFER_CONDA_LIBS:BOOL=${PREFER_CONDA_LIBS})
    list(APPEND H5PP_CMAKE_OPTIONS  "-Dhdf5_DIR:PATH=$ENV{CONDA_PREFIX};$ENV{HOME}/anaconda3")
    build_dependency(h5pp "${CMAKE_INSTALL_PREFIX}" "${H5PP_CMAKE_OPTIONS}")

    find_package(h5pp 1.1.0 HINTS ${CMAKE_INSTALL_PREFIX} PATHS PATH_SUFFIXES h5pp)
    if(h5pp_FOUND AND TARGET h5pp::h5pp)
        message(STATUS "h5pp installed successfully")
    else()
        message(FATAL_ERROR "h5pp could not be downloaded.")
    endif()
else()
    message(FATAL_ERROR "Dependency h5pp not found in your system. Set DOWNLOAD_METHOD to one of 'conan|native'")
endif()
