[xxx yyy] = outputRef.intrinsicToWorld(1242,623)
inv(affinematrix)*[xxx yyy]'

out_affinematrix*[95 248 1]'

out_affinematrix*[800 600 1]'
%[800 600]
xxxx = affinematrix*[0.5 0.5]'
[outxx outyy]=outputRef.worldToIntrinsic(xxxx(1), xxxx(2))

xxxx = affinematrix*[800 600]'
[outxx outyy]=outputRef.worldToIntrinsic(xxxx(1), xxxx(2))

[um, vm] = tforminv(tform, outxx, outyy)
tform =Chen_AffineTransform( acos(1./lat),log,0,1,0,0);
[xxx yyy] = outputRef.intrinsicToWorld(1242,623)
[u v]= transformPointsInverse(tform,xxx,yyy);

[xxx yyy] = outputRef.intrinsicToWorld(1344,903);
[u v]= transformPointsInverse(tform,xxx,yyy)

[xxx yyy] = outputRef.intrinsicToWorld(1484.5,319.5);
[u v]= transformPointsInverse(tform,xxx,yyy)
