def person_skill():
    infile_1 = open('/Users/ReneeHao/Documents/Data Cleaning Final Project/temp_person_skill.csv','r')
    infile_2 = open('/Users/ReneeHao/Documents/Data Cleaning Final Project/dup_count.csv','r')
    outfile = open('/Users/ReneeHao/Documents/Data Cleaning Final Project/out_person_skill.txt','w')
    aline = infile_2.readline()
    aline = infile_2.readline()
    dup_cnt = {}
    while (aline != ''):
        tmp = aline.split(',')
        dup_cnt[tmp[0]] = int(tmp[1])-1
        aline = infile_2.readline()
    
    aline = infile_1.readline()
    aline = infile_1.readline()
    while (aline != ''):
        tmp = aline.split(',')
        person = tmp[0]
        cnt = int(tmp[2])
        if (person in dup_cnt):
            cnt = cnt + dup_cnt[person]
            dup_cnt[person] = dup_cnt[person]-1
        newline = person + ',' + tmp[1] + ',' + str(cnt) + '\n'
        outfile.write(newline)
        aline = infile_1.readline()

    infile_1.close()
    infile_2.close()
    outfile.close()
