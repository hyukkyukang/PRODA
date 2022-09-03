import { IEVQLTable } from "../../VQL/EVQLTable";

export interface ITutorialSection {
    title: string;
    description: string;
    exampleQueryName: string;
    exampleDescription: string;
    demoDBName: string;
    syntaxExamples: IEVQLTable[];
    syntaxDescription: string;
}

export default ITutorialSection;
