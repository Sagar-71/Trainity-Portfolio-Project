
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


df=pd.read_csv(r'D:\Trainity\3a1.csv')

print(df.info())

sns.barplot(x=df['review_date'], y=df['jobs_reviewed_per_hour'])
plt.xlabel('Review Date',fontsize=11,fontweight='bold')
plt.ylabel('Frequency',fontsize=11,fontweight='bold')
plt.title('Jobs Reviewd per hour for each day in November',fontsize=14,fontweight='bold')
plt.xticks(rotation=315)
plt.tight_layout() 

for i, v in enumerate(df['jobs_reviewed_per_hour']):
    plt.text(i, v + 0.8, str(v), ha='center', fontsize=9,fontweight='bold')
    
plt.show()

df2=pd.read_csv(r'D:\Trainity\3b1.csv')

plt.hist(df2['week'],color='turquoise',edgecolor='black', bins=20, alpha=0.9)
plt.xlabel('Week',fontsize=11,fontweight='bold')
plt.ylabel('Active Users',fontsize=11,fontweight='bold')
plt.title('Number of active users in weeks of 2024',fontsize=14,fontweight='bold')
plt.show()


sns.barplot(x=df2['week'], y=df2['active_users'])
plt.xlabel('Week',fontsize=11,fontweight='bold')
plt.ylabel('Active Users',fontsize=11,fontweight='bold')
plt.title('Number of active users in weeks of 2014',fontsize=14,fontweight='bold')
plt.xticks(rotation=0)
plt.tight_layout() 
for i, v in enumerate(df2['active_users']):
    plt.text(i, v + 1, str(v), ha='center', fontsize=7,fontweight='bold')
plt.show()



df3=pd.read_csv(r'D:\Trainity\3b2.csv')



plt.figure(figsize=(10, 6))
plt.plot(df3['week'], df3['cumulative_users'], marker='o', linestyle='-', color='b')

plt.xlabel('Week', fontsize=11, fontweight='bold')  
plt.ylabel('Users', fontsize=11, fontweight='bold')  
plt.title('Cumulative Users in 2013-2014', fontsize=14, fontweight='bold')  
plt.xticks(rotation=0)  
plt.grid(True)
plt.tight_layout()
plt.show()


print(df3['new_users'].describe())


df4=pd.read_csv(r'D:\Trainity\3b4.csv')

print(df4['active_users'].describe())


df5=pd.read_csv(r'D:\Trainity\3b4_1.csv')

print(df5['device'].describe())










