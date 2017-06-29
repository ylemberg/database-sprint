UPDATE students SET date_of_birth=date_of_birth + '100 years'::interval WHERE EXTRACT(year from age(current_date, date_of_birth))>100;
