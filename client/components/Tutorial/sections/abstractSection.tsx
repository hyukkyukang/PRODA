import { IEVQATable } from "../../VQA/EVQATable";

export interface ITutorialSection {
    title: string;
    description: string;
    exampleQueryName: string;
    exampleDescription: string;
    demoDBName: string;
    syntaxExamples: IEVQATable[];
    syntaxDescription: JSX.Element;
}

export default ITutorialSection;
