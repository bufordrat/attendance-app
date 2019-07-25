# Reset the 'courses' table
Course.delete_all
c = Course.create title: "Example U of C Course",
                  quarter: "Summer",
                  year: 17

# Reset the 'users' table
User.delete_all
teichman = User.create id: 1, cnetid: 'teichman', is_teacher: true, password: 'teichman'
hopper = User.create id: 2, cnetid: 'hopper', is_teacher: false, password: 'hopper'
lovelace = User.create id: 3, cnetid: 'lovelace', is_teacher: false, password: 'lovelace'
curry = User.create id: 4, cnetid: 'curry', is_teacher: false, password: 'curry'
church = User.create id: 5, cnetid: 'church', is_teacher: false, password: 'church'


# Reset the 'class meetings' table
ClassMeeting.delete_all
cm_data = JSON.parse(open('db/class_meeting_examples.json').read)
cm_data.each do |data|
  p = ClassMeeting.new
  p.id = data["id"]
  p.meeting = data["meeting"]
  p.title = data["title"]
  p.code = data["code"]
  p.course_id = c.id
  p.is_accepting = data["is_accepting"]
  p.save
  puts p.errors.full_messages
end

# Reset the 'submitted codes' table
SubmittedCode.delete_all
sc_data = JSON.parse(open('db/submitted_code_examples.json').read)
sc_data.each do |data|
  p = SubmittedCode.create user_id: data["user_id"],
                           created_at: data["created_at"],
                           is_legit: data["is_legit"],
                           code: data["code"]
  puts p.errors.full_messages
end

# Reset the 'presences' table
Presence.delete_all
p_data = JSON.parse(open('db/presence_examples.json').read)
p_data.each do |data|
  p = Presence.create user_id: data['user_id'],
                      class_meeting_id: data['class_meeting_id']
  puts p.errors.full_messages
end


puts "#{User.count} users."
puts "#{Course.count} courses."
puts "#{SubmittedCode.count} submitted codes."
puts "#{Presence.count} presences."
puts "#{ClassMeeting.count} class meetings."
