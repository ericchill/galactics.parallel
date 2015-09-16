      subroutine dbhplot(apot,lmax,nr,dr)
      parameter(ipmax=1000)
      real apot(20,0:20000),rp(1000),pplot(1000),iplot(ipmax)
      data ifirst /0/
      save rp,ifirst,nrp
      character*40 toplbl

      if (ifirst.eq.0) then
         ifirst=1
         nrp=1
         rp(nrp)=log10(dr)
         iplot(nrp)=1
         do ir=1,nr
            r=log10(ir*dr)
            if (r-rp(nrp).gt.0.01) then
               nrp=nrp+1
               rp(nrp)=r
               iplot(nrp)=ir
               if (nrp.ge.ipmax) then
                  write(*,*) 'Not able to plot all points in dbhplot.'
                  write(*,*) 'Increase ipmax parameter & recompile!'
                  goto 4
               endif
            endif
         enddo
      endif

 4    do l=0,lmax,2
         j=l/2+1
         if (l.eq.0) then
            pmax=0.
         else
            pmax=-1e31
         endif
         pmin=1e31
         do irp=1,nrp
            pp=apot(j,iplot(irp))    
            if (l.eq.0) then
               pp=min(pp,0.)
            else
               pmax=max(pmax,pp)
            endif
            pmin=min(pmin,pp)
            pplot(irp)=pp
         enddo
cpg         call pgenv(log10(dr),log10(nr*dr),pmin,pmax,0,1)
cpg         call pgline(nrp,rp,pplot)
         write(toplbl,'(''l='',i3)') l
cpg         call pglabel('log10(R)','POT',toplbl)
      enddo
      return
      end
