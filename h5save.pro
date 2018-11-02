; hdf5_datafile::save
;   Saves variables from memory to the datafile.
;
; NAMES: 
; 
; (There must be a better way to do this.)
; IDL code to generate the parameter list for copy and paste:
; varlist = 'pro hdf5_datafile::save, '
; for i = 1, 255 do varlist += 'v' + string(i, format='(i0)') + ', ' 
; varlist += ' $'
; print, varlist
;
pro h5save, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46, v47, v48, v49, v50, v51, v52, v53, v54, v55, v56, v57, v58, v59, v60, v61, v62, v63, v64, v65, v66, v67, v68, v69, v70, v71, v72, v73, v74, v75, v76, v77, v78, v79, v80, v81, v82, v83, v84, v85, v86, v87, v88, v89, v90, v91, v92, v93, v94, v95, v96, v97, v98, v99, v100, v101, v102, v103, v104, v105, v106, v107, v108, v109, v110, v111, v112, v113, v114, v115, v116, v117, v118, v119, v120, v121, v122, v123, v124, v125, v126, v127, v128, v129, v130, v131, v132, v133, v134, v135, v136, v137, v138, v139, v140, v141, v142, v143, v144, v145, v146, v147, v148, v149, v150, v151, v152, v153, v154, v155, v156, v157, v158, v159, v160, v161, v162, v163, v164, v165, v166, v167, v168, v169, v170, v171, v172, v173, v174, v175, v176, v177, v178, v179, v180, v181, v182, v183, v184, v185, v186, v187, v188, v189, v190, v191, v192, v193, v194, v195, v196, v197, v198, v199, v200, v201, v202, v203, v204, v205, v206, v207, v208, v209, v210, v211, v212, v213, v214, v215, v216, v217, v218, v219, v220, v221, v222, v223, v224, v225, v226, v227, v228, v229, v230, v231, v232, v233, v234, v235, v236, v237, v238, v239, v240, v241, v242, v243, v244, v245, v246, v247, v248, v249, v250, v251, v252, v253, v254, v255, $
    filename=filename, names=names, create=create, quiet=quiet, compress=compress, chunk_dimensions=chunk_dimensions, member_names=member_names

    compile_opt idl2, hidden
    on_error, 2

    max_vars = 255
    if n_params() gt max_vars then begin
        message, 'Can only save ' + max_vars + ' variables'
    endif
    
    if n_elements(names) eq 0 then names=strarr(max_vars)

    if n_elements(filename) eq 0 then begin
        filename = dialog_pickfile(filter="*.hdf5;*.h5;*.hdf")
        if filename eq '' then $
            message, 'No file selected; nothing saved.', /info
            return
    endif


    savefile = obj_new('h5file', filename, create=create)
    for i = 1, n_params() do begin
        str_i = string(i, format='(i0)')
        success = execute('varname = scope_varname(v' + str_i + ', level=-1)') 
        if ~ success then begin
            message, 'Problem determining name of variable #' + str_i
        endif 
        if names[i-1] then varname = names[i-1]
        if ~ varname then begin
            varname = 'v' + str_i
            j = i
            while savefile->is_dataset(varname) do begin
                j += 1
                varname = 'v' + string(j, format='(i0)')
            endwhile 
            message, /info, 'Warning: variable #' + str_i $
               + ' is not a named variable.  Will be saved as "' + varname + '".'
        endif 
        if savefile->is_dataset(varname) then begin
            dataset = savefile->get(varname)
            write_string = 'dataset->write, v' + str_i  
        endif else begin
            write_string = 'dataset = savefile->create(varname, v' + str_i + ', compress=compress, chunk_dimensions=chunk_dimensions, member_names=member_names)'
        endelse
        if ~keyword_set(quiet) then print, 'Saving "' + varname + '"...'
        success = execute(write_string)
        if ~ success then $
            message, 'Error saving variable "' + varname + '".'
        obj_destroy, dataset
    endfor
    obj_destroy, savefile
end
