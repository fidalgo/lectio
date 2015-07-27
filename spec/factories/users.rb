first_names = ['Kristina','Paige','Sherri','Gretchen','Karen','Patrick','Elsie',
  'Hazel','Malcolm','Dolores','Francis','Sandy','Marion','Beth','Julia','Jerome',
  'Neal','Jean','Kristine','Crystal','Alex','Eric','Wesley','Franklin','Claire',
  'Marian','Marcia','Dwight','Wayne','Stephanie','Neal','Gretchen','Tim','Jerome',
  'Shelley','Priscilla','Elsie','Beth','Erica','Douglas','Donald','Katherine','Paul',
  'Patricia','Lois','Louis','Christina','Darlene','Harvey','William','Frederick',
  'Shirley','Jason','Judith','Gretchen','Don','Glenda','Scott','Pat','Michelle',
  'Jessica','Evan','Melinda','Calvin','Eugene','Vickie','Luis','Allan','Melanie',
  'Marianne','Natalie','Caroline','Arlene','Kyle','Calvin','Gary','Samantha',
  'Sara','Stacy','Gladys','Mike','Lynne','Faye','Diana','Leon','Ethel','Steve',
  'Alison','Sherri','Patsy','Kelly','Stacy','Curtis','Dana','Jennifer','Brett',
  'Brandon','Keith','Joann']

last_names = ['Chung','Chen','Melton','Hill','Puckett','Song','Hamilton','Bender',
  'Wagner','McLaughlin','McNamara','Raynor','Moon','Woodard','Desai','Wallace',
  'Lawrence','Griffin','Dougherty','Powers','May','Steele','Teague','Vick',
  'Gallagher','Solomon','Walsh','Monroe','Connolly','Hawkins','Middleton','Goldstein',
  'Watts','Johnston','Weeks','Wilkerson','Barton','Walton','Hall','Ross','Chung',
  'Bender','Woods','Mangum','Joseph','Rosenthal','Bowden','Barton','Underwood',
  'Jones','Baker','Merritt','Cross','Cooper','Holmes','Sharpe','Morgan','Hoyle',
  'Allen','Rich','Rich','Grant','Proctor','Diaz','Graham','Watkins','Hinton','Marsh',
  'Hewitt','Branch','Walton','Brien','Case','Watts','Christensen','Parks','Hardin',
  'Lucas','Eason','Davidson','Whitehead','Rose','Sparks','Moore','Pearson','Rodgers',
  'Graves','Scarborough','Sutton','Sinclair','Bowman','Olsen','Love','McLean',
  'Christian','Lamb','James','Chandler','Stout']


FactoryGirl.define do
  factory :user do
    name {"#{first_names.sample} #{last_names.sample}"}
    email  {"#{name.downcase.gsub!(' ', '.')}@example.com"}
    password {"#{name.downcase.gsub!(' ', '.')}!123"}
    password_confirmation {"#{name.downcase.gsub!(' ', '.')}!123"}
  end

end
