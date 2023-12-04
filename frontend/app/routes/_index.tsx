import type { MetaFunction } from "@remix-run/node";
import Patch from "~/components/Patch";
import {PatchResponse} from "~/bindings/PatchResponse";
import {PatchReason} from "~/bindings/PatchReason";

export const meta: MetaFunction = () => {
  return [
    { title: "New Remix App" },
    { name: "description", content: "Welcome to Remix!" },
  ];
};

export default function Index() {
  const examplePatch: PatchResponse = {
    artists: [""], name: "", organizer: "", pictures: [""], reason: "dryck", release_date: "", tags: [""], ulid: ""
  }
  const patches = [<Patch patch={examplePatch} />]
  return (
    <>
      <h1>MärkeDB</h1>
      {patches}
    </>
  );
}
