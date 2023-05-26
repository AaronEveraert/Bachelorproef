namespace my.Tickets;


using { managed} from '@sap/cds/common';


entity Tickets: managed  {
    key ID      : UUID;
    title  : String(20);
    description   : String(244);
    name      : String(20);    
    type     : String(20);
    email       : String(50);
    status : String(20);
    date   : Date;
    solution     : String(244);
}

