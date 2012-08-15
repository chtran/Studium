Factory.define :message do |f|
  f.sequence.username "abc"
  f.password "secret"
  f.password_confirmation {|u| u.password}
  f.sequence.email ""
end
