import math 
import time
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import LinearLocator
from os.path import join, dirname, abspath
import shapefile
import xlrd

Province=['Anhui','Aomen']
PColor=['lightgreen','grey','green','blue','red','magenta',
        'pink','purple','silver','skyblue','yellow','violet',
        'orange','gold','cyan','brown','blueviolet','lightblue',
        'chocolate','black']

def readShapeData(path, filename):
    myFile=path+filename
    sf=shapefile.Reader(myFile)
    print("### Reading Geographic Data ###")
    return (sf)

def plotMapElement(sf,Color,size,flag):
    shapes = sf.shapes()
    if(sf.shapeTypeName=="POINT"):
       npoint = len(sf)
       xx=np.zeros((npoint,1),dtype = np.float32)
       yy=np.zeros((npoint,1),dtype = np.float32)
       for i in range(npoint):
          xx[i]=shapes[i].points[0][0]
          yy[i]=shapes[i].points[0][1]
       plt.scatter(xx,yy,s=size,color=Color)
    else:
       for i in range(len(sf)):
           npoint=len(shapes[i].points)
           npart=len(shapes[i].parts)
           for j in range(npart):
               if (j == npart-1):
                  mpoint = npoint-shapes[i].parts[j]
               else:
                  mpoint = shapes[i].parts[j+1]-shapes[i].parts[j]
               xx=np.zeros((mpoint,1),dtype = np.float32)
               yy=np.zeros((mpoint,1),dtype = np.float32)
               for k in range(mpoint):
                   xx[k]=shapes[i].points[shapes[i].parts[j]+k][0]
                   yy[k]=shapes[i].points[shapes[i].parts[j]+k][1]
               if (sf.shapeTypeName=="POLYLINE"):
                   if(flag <1):
                      plt.plot(xx,yy,linewidth=size,color=Color)
                   else:
                      plt.plot(xx,yy,'-.',linewidth=size,color=Color)
               if (sf.shapeTypeName=="POLYGON"):
                   if(flag <1):
                      plt.plot(xx,yy,color=Color)
                   else:
                      plt.fill(xx,yy,facecolor=Color,edgecolor='grey')
    return 0

def plotMark(mark,x,y,Color,size):
    plt.annotate(mark,xy=(x,y),color=Color,fontsize=size,xycoords='data')
    return 0

def plotWorldTopicMap(figF,Title,w,h):
    shapePath = "./datafolder/"
    sf=readShapeData(shapePath,"continent")
    width  = w/100.0
    height = h/100.0
    (x1,x2,y1,y2) = (-180,180,-90,90)
    height=width*(y2-y1)/(x2-x1)
    
    fig=plt.figure(figsize=(width,height))
    ax=fig.gca()
    plt.axis([x1,x2,y1,y2])
    plt.rcParams['font.sans-serif']=['SimHei']
    plt.rcParams['axes.unicode_minus']=False
    plt.xlabel('LONGITUDE',fontsize=16)
    plt.ylabel('LATITUDE',fontsize=16)
    ax.xaxis.set_major_locator(LinearLocator(19))
    ax.yaxis.set_major_locator(LinearLocator(10))
    plt.title(Title,fontsize=20)

    plotMapElement(sf,'grey',1,0)
    plotTopicItem(1)

    plt.grid(True,linestyle=':')
    plt.show()
    fig.savefig(figF,dpi=100,bbox_inches='tight')
    return 0


def plotTopicItem(kf):
    print("### Plot Topic ###")
    EQColor=['grey','lightblue','lightgreen','green','chocolate',
        'blueviolet','blue','magenta','red','gold']
    topicFile="./datafolder/eq2017.xlsx"
    (neq,eqm,x,y,z,teq)=readExcel(topicFile)
    eqn=np.zeros((10),dtype=np.int32)
    for i in range(neq):
        k=math.floor(eqm[i])
        eqn[k] = eqn[k] +1
    for k in range(3,9,1):
        xx =np.zeros((eqn[k]),dtype=np.float32)
        yy =np.zeros((eqn[k]),dtype=np.float32)
        i  =0
        for j in range(neq):
            if(math.floor(eqm[j]) == k):
                xx[i] = x[j]
                yy[i] = y[j]
                i = i+1
        plt.scatter(xx,yy,s=(k-3)*5, color=EQColor[k])
    if(kf == 1):
        for k in range(2,10,1):
            xk =20.0*k-40.0
            yk =-80.0
            plt.scatter(xk,yk,s=(k-2)*5, color=EQColor[k])
            plt.annotate(("%d"%(k)),xy=(xk+5,yk-2),color=EQColor[k],fontsize=12,xycoords='data' )
    if(kf == 0):
        for k in range(2,10,1):
            xk =3.0*k+65.0
            yk =16.0
            plt.scatter(xk,yk,s=(k-2)*5, color=EQColor[k])
            plt.annotate(("%d"%(k)),xy=(xk+0.5,yk),color=EQcolor[k],fontsize=12,xycoords='data' )
    return 0

def readExcel(excelFile):
     print("Excel file: %s"%(excelFile))
     workBook=xlrd.open_workbook(excelFile)
     allSheetNames=workBook.sheet_names()
     print(allSheetNames)
     sheetName=allSheetNames[0]
     #sheetName='events'
     sheetContent=workBook.sheet_by_name(sheetName)
     nearthquake=sheetContent.nrows-1
     rows=sheetContent.row_values(0)
     #for i in range(sheetContent.ncols):
     col1=sheetContent.col_values(1)
     eqmagnitude=np.zeros((nearthquake),dtype=np.float32)
     for i in range(nearthquake):
         eqmagnitude[i]=float(col1[i+1])
     eqn=np.zeros((10),dtype=np.int32)
     
     for i in range(nearthquake):
         k =math.floor(eqmagnitude[i])
         eqn[k] = eqn[k] +1
     x=np.zeros((nearthquake),dtype=np.float32)
     y=np.zeros((nearthquake),dtype=np.float32)
     z=np.zeros((nearthquake),dtype=np.float32)
     teq=np.zeros((nearthquake),dtype=np.float32)
     for i in range(nearthquake):
         x[i] = float(sheetContent.cell_value(i+1,3))
         y[i] = float(sheetContent.cell_value(i+1,2))
         z[i] = float(sheetContent.cell_value(i+1,4))
         teq[i] = date2Float(sheetContent.cell_value(i+1,0))
     return(nearthquake,eqmagnitude,x,y,z,teq)

def plotTimeDist(figF,Title,w,h):
    topicFile="./datafolder/eq2017.xlsx"
    EQColor=['grey','lightblue','lightgreen','green','chocolate',
        'blueviolet','blue','magenta','red','gold']
    (neq,eqm,x,y,z,teq) = readExcel(topicFile)
    width = w/100.0
    height= h/100.0
    tmin=teq[:].min()
    tmax=teq[:].max()
    x1=math.floor(tmin)
    x2=math.floor(tmax+1)
    y1=0.0
    y2=10.0
    fig=plt.figure(figsize=(width,height))
    ax=fig.gca()
    plt.axis([x1,x2,y1,y2])
    plt.rcParams['font.sans-serif']=['SimHei']
    plt.rcParams['axes.unicode_minus']=False
    plt.xlabel('DATE (YEAR)',fontsize=16)
    plt.ylabel('MAGNITUDE',fontsize=16)
    ax.xaxis.set_major_locator(LinearLocator(x2-x1+1))
    ax.yaxis.set_major_locator(LinearLocator(11))
    plt.title(Title,fontsize=20)
    
    eqn=np.zeros((10),dtype=np.int32)
    for i in range(neq):
        k=math.floor(eqm[i])
        eqn[k]=eqn[k]+1
    for k in range(1,9,1):
        if (eqn[k]>0):
            xx=np.zeros((eqn[k]),dtype=np.float32)
            yy=np.zeros((eqn[k]),dtype=np.float32)
            i=0
            for j in range(neq):
                if (math.floor(eqm[j]) ==k):
                    xx[i] =teq[j]
                    yy[i] =eqm[j]
                    i=i+1
            plt.scatter(xx,yy,s=k*5,color=EQColor[k])
    plt.grid(True,linestyle=':')
    plt.show()
    fig.savefig(figF,dpi=100,bbox_inches='tight')
    return 0

def date2Float(ss):
    dm=[0,0,31,59,90,120,151,181,212,243,273,304,334]
    ff=2017#float(ss[0:4])#+float(dm[int(ss[5:7])]+int(ss[8:10]))/365.0
    return ff

if __name__ == '__main__':
    print("Earthquake Map")
    #start = time.time()
    plotWorldTopicMap("EQ-World.png","EarthQuake Map (2017-2019)",2000,1600)
   # now = time.time()
   # dtime = now - start
   

       

        

