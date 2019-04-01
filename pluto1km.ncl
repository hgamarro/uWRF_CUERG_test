load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"

begin

a = addfile("./wrfinput_d03.nc","w")
b = addfile("./geo_em.d03.nc","w")

dims = getfilevardimsizes(a,"HEIGHT_HISTOGRAMS")
print(dims)

dims2 = getfilevardimsizes(b,"HI_URB2D_NY")
print(dims2)


dimsn = getfilevardims(a,"HEIGHT_HISTOGRAMS")
print(dimsn)


dimsn2 = getfilevardims(b,"HI_URB2D_NY")
print(dimsn2)



x=84
y=81
z=15

lu=a->LU_INDEX
lp=a->BUILD_AREA_FRACTION
bh=a->BUILD_HEIGHT
lb=a->BUILD_SURF_RATIO
hi=a->HEIGHT_HISTOGRAMS

lup=b->LCLU_URB2D_NY
lpp=b->LP_URB2D_NY
bhp=b->HGT_URB2D_NY
lbp=b->LB_URB2D_NY
hip=b->HI_URB2D_NY

hip!1="urban_vertical_layers_stag"


newlu=new((/1,y,x/),float)
newlp=new((/1,y,x/),float)
newlb=new((/1,y,x/),float)
newhi=new((/1,z,y,x/),float)
newbh=new((/1,y,x/),float)


do i=0,x-1
 do j=0,y-1
 
 if(lup(0,j,i).gt.0) then
newlu(0,j,i)=floattointeger(lup(0,j,i))
else
newlu(0,j,i)=lu(0,j,i)

end if

 if(lpp(0,j,i).gt.0) then
newlp(0,j,i)=lpp(0,j,i)

else
newlp(0,j,i)=lp(0,j,i)

end if

 if(lbp(0,j,i).gt.0) then
newlb(0,j,i)=lbp(0,j,i)

else
newlb(0,j,i)=lb(0,j,i)

end if

 if(bhp(0,j,i).gt.0) then
newbh(0,j,i)=bhp(0,j,i)

newhi(0,:,j,i)=hip(0,:,j,i)


else
newbh(0,j,i)=bh(0,j,i)

newhi(0,:,j,i)=hi(0,:,j,i)

end if


end do

end do

print(bh(0,56,56))

a->LU_INDEX=newlu
a->BUILD_AREA_FRACTION=newlp
a->BUILD_SURF_RATIO=newlb
a->BUILD_HEIGHT=newbh
a->HEIGHT_HISTOGRAMS=newhi

bhf=a->BUILD_HEIGHT

print(bhf(0,56,56))

end

