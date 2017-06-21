img_path1 = 'data/IGI-UM_Soest-City_GSD5cm-Nadir.jpgresize.pngcropped.png';
img_path2 = 'data/IGI-UM_Soest-City_GSD7cm-ObliqueEast.jpgresize.pngcropped.png';

[out_match, out_features1, out_features2, out_desc1, out_desc2] =...
    Chen_Match2ImgsByViewsphereSimulation(img_path1, img_path2, opts);