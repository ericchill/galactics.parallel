      function rcirc(am)
      parameter(pi=3.1415926535)
      parameter(nrmax=1000)
      common /potconstants/ apot(20,0:80000), frad(20,0:80000), 
     +     dr, nr, lmax, potcor
      common /legendre/ plcon(0:40)
      common /gparameters/  c, v0, a,
     +                      cbulge, v0bulge, abulge, 
     +                      psi0, haloconst, bulgeconst,
     +                      rmdisk, rdisk, zdisk, outdisk, drtrunc,
     +                      potcor1
      common /moreconstants/ v02, v03, rdisk2, diskconst, rho0
      common /diskpars/ sigr0, disksr, nrdisk

      dimension rtab(80000),amtab(80000),rtab2(80000)
      data ifirst /0/

      save ifirst,rtab,amtab,rtab2

c make a spline fit to [Rcirc/sqrt(Lcirc)] vs. Lcirc.
c this is ~ constant at the origin, and goes like Lcirc**1.5 
c at large radii (where the potential is Kepler).

      if (ifirst.eq.0) then
        
        do i=1,nr
           r=(i-1)*dr
           call omekap(r,om,t)
           amtab(i)=om*r*r
           rtab(i)=1./sqrt(om)
        enddo
        slopeinf=1.5*rtab(nrdisk)/amtab(nr)
        call splined(amtab,rtab,nr,1.e32,slopeinf,rtab2)
        ifirst=1
      endif

      aam=abs(am)
      if (aam.gt.amtab(nr)) then
        rcirc=rtab(nr)*(aam/amtab(nr))**2
        write(0,*) rcirc
      else
        call splintd(amtab,rtab,rtab2,nr,aam,rc)
        rcirc=rc*sqrt(aam)
      endif
      return
      end
