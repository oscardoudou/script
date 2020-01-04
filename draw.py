import matplotlib.pyplot as plt

f = [ 1, 15 ]
t = [ 11,28 ]
r = [-6, -5]
y = [ 1, 2]
f_a = ["02-01","02-15"]
t_a = ["02-11","02-28"]
color_f=['aqua']
color_t=['lime']
color_r = ['r']
fig = plt.figure()
ax = fig.add_subplot(111)

#place date point
plt.scatter(f,y, s=100 ,marker=2, c=color_f)
plt.scatter(t,y, s=100 ,marker=2, c=color_t)
plt.scatter(r,y, s=100 ,marker="+", c=color_r)

#draw lines 
for dot_f,dot_t in zip(zip(f,y),zip(t,y)) :
    print(dot_f[0] , dot_f[1])
    print(dot_t[0] , dot_t[1])
    #this is not intuitive to draw line between points, intuitive way should be passed two point tuple, namely drawLine(dot_f,dot_t)
    plt.plot( [dot_f[0],dot_t[0]] ,[dot_f[1],dot_t[1]], 'g-', linewidth = 3 ) 
# [ plt.plot( [dot_x,dot_x] ,[dot_y,dot_y], '-', linewidth = 3 ) for dot_x,dot_y in zip(f,y) ]

# add annotation
for i, a in enumerate(f_a):
    plt.annotate(a, (f[i], y[i]))

for i, a in enumerate(t_a):
    plt.annotate(a, (t[i], y[i]))

left,right = ax.get_xlim()
low,high = ax.get_ylim()
plt.arrow( left, 0, right -left, 0, length_includes_head = True, head_width = 0.15 )
plt.arrow( 0, low, 0, high-low, length_includes_head = True, head_width = 0.15 ) 

plt.grid()

plt.show()